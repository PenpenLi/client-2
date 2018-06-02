#include "shared_data.h"
#include "msg.h"
#include "msg_server.h"
#include "GMTools.h"

typedef boost::shared_ptr<msg_base> msg_ptr;
boost::shared_ptr<msg_base> create_msg_1(int cmd)
{
	DECLARE_MSG_CREATE();
	REGISTER_CLS_CREATE(msg_user_login_ret_game);
	REGISTER_CLS_CREATE(msg_common_reply);
	REGISTER_CLS_CREATE(msg_query_data_rsp);
	END_MSG_CREATE();
	return ret_ptr;
}

boost::shared_ptr<msg_base> create_msg(int cmd)
{
	DECLARE_MSG_CREATE();
	REGISTER_CLS_CREATE(msg_user_login_ret);
	REGISTER_CLS_CREATE(msg_common_reply);
	REGISTER_CLS_CREATE(msg_player_info);
	REGISTER_CLS_CREATE(msg_player_leave);
	REGISTER_CLS_CREATE(msg_chat_deliver);
	REGISTER_CLS_CREATE(msg_same_account_login);
	REGISTER_CLS_CREATE(msg_live_show_start);
	REGISTER_CLS_CREATE(msg_turn_to_show);
	REGISTER_CLS_CREATE(msg_host_apply_accept);
	REGISTER_CLS_CREATE(msg_game_data);
	REGISTER_CLS_CREATE(msg_channel_server);
	REGISTER_CLS_CREATE(msg_user_login_channel);
	REGISTER_CLS_CREATE(msg_image_data);
	REGISTER_CLS_CREATE(msg_user_image);
	REGISTER_CLS_CREATE(msg_account_info_update);
	REGISTER_CLS_CREATE(msg_verify_code);
	REGISTER_CLS_CREATE(msg_check_data_ret);
	REGISTER_CLS_CREATE(msg_live_show_stop);
	REGISTER_CLS_CREATE(msg_sync_item);
	REGISTER_CLS_CREATE(msg_region_data);
	REGISTER_CLS_CREATE(msg_srv_progress);
	REGISTER_CLS_CREATE(msg_sync_token);
	REGISTER_CLS_CREATE(msg_confirm_join_game_deliver);
	REGISTER_CLS_CREATE(msg_173user_login_ret);
	REGISTER_CLS_CREATE(msg_room_create_ret);
	REGISTER_CLS_CREATE(msg_enter_private_room_ret);
	REGISTER_CLS_CREATE(msg_get_bank_info_ret);
	REGISTER_CLS_CREATE(msg_present_data);
	REGISTER_CLS_CREATE(msg_private_room_remove);
	REGISTER_CLS_CREATE(msg_private_room_players);
	REGISTER_CLS_CREATE(msg_switch_game_server);
	REGISTER_CLS_CREATE(msg_acc_info_invalid);
	REGISTER_CLS_CREATE(msg_black_account);
	REGISTER_CLS_CREATE(msg_user_head_and_headframe);
	END_MSG_CREATE();
	return ret_ptr;
}


host_info::host_info()
{
	gameid_ = -1;
	popular_ = 0;
	online_players_ = 0;
	is_online_ = 0;
	avshow_start_ = 0;
	roomid_ = -1;	//房间ID
	memset(roomname_, 0, 128);	//房间名称
	memset(host_uid_, 0, 64); //主播ID
	memset(thumbnail_, 0, 256); //缩略图
}

main_controller::main_controller()
{
	the_role_.reset(new koko_player());
}

main_controller::~main_controller()
{

}

boost::shared_ptr<main_controller> gins;
main_controller * main_controller::get_instance()
{
	if (!gins) {
		gins.reset(new main_controller());
	}
	return gins.get();
}

void main_controller::free_instance()
{
	if (gins)
		gins->stop();
}

void main_controller::stop()
{
	center_connector_.reset();
	channel_connector_.reset();
	game_connector_.reset();
	ios_.stop();
}

int main_controller::connect_to_acc(std::string ip, int port)
{
	if (!center_connector_ || !center_connector_->isworking()) {
		center_connector_.reset(new user_connector(ios_));
	}
	if (!center_connector_->isworking()) {
		if (center_connector_->connect(ip, port) != 0) {
			return -1;
		}
	}
	return 0;
}

int main_controller::connect_to_channel()
{
	if (!channel_connector_ || !channel_connector_->isworking()) {
		channel_connector_.reset(new user_connector(ios_));
	}

	if (!channel_connector_->isworking()) {
		if (channel_connector_->connect(chn_srv_ip_, chn_srv_port_) != 0) {
			return -1;
		}
	}
	return 0;
}

int main_controller::connect_to_game()
{
	if (!game_connector_ || !game_connector_->isworking()) {
		game_connector_.reset(new user_connector(ios_));
	}
	if (!game_connector_->isworking()) {
		if (game_connector_->connect(game_srv_ip_, game_srv_port_) != 0) {
			return -1;
		}
	}
	return 0;
}

extern std::string			md5_hash(std::string sign_pat);
void main_controller::net_login_to_acc(std::string uname, std::string psw)
{
	msg_user_login msg;
	msg.acc_name_ = uname;
	msg.pwd_hash_ = md5_hash(psw);
	msg.machine_mark_ = get_guid();
	std::string	sign_pat = msg.acc_name_ + msg.pwd_hash_ + msg.machine_mark_ + "{51B539D8-0D9A-4E35-940E-22C6EBFA86A8}";
	std::string sign_key = md5_hash(sign_pat);
	msg.sign_ = sign_key;
	send_msg_to_acc(msg);
}

int main_controller::send_msg_to_acc(msg_base& msg)
{
	if(center_connector_)
		return ::send_json(center_connector_, msg);
	return -1;
}

int main_controller::send_msg_to_channel(msg_base& msg)
{
	if (channel_connector_)
		return ::send_json(channel_connector_, msg);
	return -1;
}

int main_controller::send_msg_to_game(msg_base& msg)
{
	if (game_connector_)
		return ::send_json(game_connector_, msg);
	return -1;
}

int main_controller::step()
{
	ios_.reset();
	ios_.poll();

	handle_msgs();

	return 0;
}

void main_controller::handle_msgs()
{
	if (center_connector_.get()) {
		bool got_msg = false;
		do {
			got_msg = false;
			msg_ptr pmsg = pickup_msg_from_socket(center_connector_, create_msg, got_msg);
			if (pmsg.get()) {
				pmsg->from_sock_ = center_connector_;
				int ret = pmsg->handle_this();
				main_controller::get_instance()->mainw_->on_msg(*pmsg);
			}
		} while (got_msg && center_connector_.get());
	}

	if (channel_connector_.get()) {
		bool got_msg = false;
		do
		{
			got_msg = false;
			msg_ptr pmsg = pickup_msg_from_socket(channel_connector_, create_msg, got_msg);
			if (pmsg.get()) {
				pmsg->from_sock_ = channel_connector_;
				int ret = pmsg->handle_this();
				main_controller::get_instance()->mainw_->on_msg(*pmsg);
			}
		} while (got_msg && channel_connector_.get());
	}

	if (game_connector_.get()) {
		bool got_msg = false;
		do
		{
			got_msg = false;
			msg_ptr pmsg = pickup_msg_from_socket(game_connector_, create_msg_1, got_msg);
			if (pmsg.get()) {
				pmsg->from_sock_ = game_connector_;
				int ret = pmsg->handle_this();
				main_controller::get_instance()->mainw_->on_msg(*pmsg);
			}
		} while (got_msg && game_connector_.get());
	}

}

void main_controller::net_get_channel(int gameid)
{
	msg_get_game_coordinate msg;
	msg.gameid_ = gameid;
	send_msg_to_acc(msg);
}

void main_controller::net_login_to_channel()
{
	msg_user_login_channel msg;
	msg.uid_ = the_role_->uID_.toUtf8();
	msg.sn_ = srv_sn_;
	msg.token_ = srv_token_.toUtf8();
	msg.device_ = "PC";
	send_msg_to_channel(msg);
}

void main_controller::net_get_gameserver(int gameid)
{
	msg_alloc_game_server msg;
	msg.game_id_ = gameid;
	send_msg_to_channel(msg);
}

void main_controller::net_login_to_game()
{
	msg_platform_login_req msg;
	msg.uid_ = the_role_->uID_.toUtf8();
	msg.uname_ = the_role_->nickName_.toUtf8();
	msg.iid_ = the_role_->iID_;
	msg.platform_ = "koko";
	msg.sn_ = lx2s(srv_sn_);
	msg.url_sign_ = srv_token_.toUtf8();
	send_msg_to_game(msg);
}

void main_controller::net_send_cmd(std::string param)
{
	msg_query_data_req msg;
	msg.params_ = param;
	send_msg_to_game(msg);
}

void user_connector::close(bool passive /*= false*/)
{
	native_socket::close(passive);
}
