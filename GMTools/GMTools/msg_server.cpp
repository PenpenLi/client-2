#include "msg_server.h"
#include <map>
#include "utility.h"
#include "shared_data.h"
#include "GMTools.h"

int this_new_bk_psw = 0;


extern main_controller* the_instance;

int msg_common_reply::handle_this()
{
	if (rp_cmd_ == GET_CLSID(msg_user_register)){
		//账户名已存在
	
	}
	else if (rp_cmd_ == GET_CLSID(msg_alloc_game_server)){
		
	}
	else if (rp_cmd_ == GET_CLSID(msg_user_login)){

	}
	else if (rp_cmd_ == GET_CLSID(msg_change_account_info)){

	}
	else if (rp_cmd_ == GET_CLSID(msg_get_game_coordinate)){
		
	}
	else if (rp_cmd_ == GET_CLSID(msg_user_login_channel)){
		
	}
	else if (rp_cmd_ == GET_CLSID(msg_transfer_gold_to_game)){
	}
    else if(rp_cmd_ == GET_CLSID(msg_modify_acc_name)){
    }
    else if (rp_cmd_ == GET_CLSID(msg_modify_nick_name)){
    }
	return error_noerror;
}

int msg_player_info::handle_this()
{
	boost::shared_ptr<koko_player> player;
	player.reset(new koko_player);
	player->uID_ = QString::fromLatin1(uid_);

	std::string cnt = nickname_;
	std::replace(cnt.begin(), cnt.end(), '%', '_');
	player->nickName_ = QString::fromUtf8(cnt.c_str());

	player->iID_ = (LONGLONG)iid_;
	player->gold_ = (LONGLONG)gold_;
	player->vipLevel_ = vip_level_;
	player->chanelID_ = long(channel_);
	player->isagent_ = isagent_ & 0xFFFF;
	player->is_bot_ = (isagent_ >> 16) & 0x1;
	player->is_newbee_ = (isagent_ >> 17) & 0x1;

	return 0;
}

int msg_user_login_ret_ex::handle_this()
{
	the_instance->the_role_->uID_ = uid_;
	std::string cnt = nickname_;
	std::replace(cnt.begin(), cnt.end(), '%', '_');
	the_instance->the_role_->nickName_ = QString::fromUtf8(cnt.c_str());

	the_instance->srv_token_ = token_;
	the_instance->the_role_->iID_ = iid_;
	the_instance->the_role_->gold_ = gold_;
	the_instance->the_role_->gold_game_ = game_gold_;
	the_instance->the_role_->gold_free_ = game_gold_free_;
	the_instance->the_role_->gender_ = gender_;
	the_instance->the_role_->age_ = age_;
	the_instance->the_role_->mobile_ = phone;
	the_instance->the_role_->email = email_;
	the_instance->the_role_->idcard = idcard_;
	the_instance->the_role_->byear_ = byear_;
	the_instance->the_role_->bmonth_ = bmonth_;
	the_instance->the_role_->region1_ = region1_;
	the_instance->the_role_->region2_ = region2_;
	the_instance->the_role_->region3_ = region3_;
	the_instance->the_role_->bday_ = bday_;
	the_instance->the_role_->isagent_  = isagent_ & 0xFFFF;
	the_instance->the_role_->is_newbee_ = (isagent_ >> 17) & 0x1;
	the_instance->the_role_->address_ = address_;
	the_instance->the_role_->email_v_ = email_verified_;
	the_instance->the_role_->mobile_v_ = phone_verified_;
	the_instance->srv_sn_ = sequence_;
    the_instance->the_role_->appkey_ = app_key_;
    the_instance->the_role_->part_name = party_name_;
    if (the_instance->the_role_->part_name == "tourist"){
        the_instance->the_role_->is_tourist = 1;
    }
	return 0;
}

int msg_player_leave_channel::handle_this()
{
	return error_noerror;
}

int msg_chat_deliver::handle_this()
{
	return 0;
}

int msg_same_account_login::handle_this()
{

	return 0;
}

int msg_live_show_stop::handle_this()
{
	return 0;
}

int msg_live_show_start::handle_this()
{

	return 0;
}

int msg_turn_to_show::handle_this()
{
	return 0;
}

int msg_host_apply_accept::handle_this()
{
	return 0;
}

int msg_game_data::handle_this()
{
	gamei_ptr pgame;
	auto it = the_instance->all_games.find(inf.id_);
	if (it == the_instance->all_games.end()){
		pgame.reset(new game_info);
		the_instance->all_games.insert(std::make_pair(inf.id_, pgame));
	}
	else{
		pgame = it->second;
	}
	*pgame = inf;
	return error_noerror;
}

//如果这次的服务器和上次的一样，则什么事情都不做。
int msg_channel_server::handle_this()
{
	if (the_instance->chn_srv_ip_ == ip_ && the_instance->chn_srv_port_ == port_) {
		the_instance->chn_srv_for_game_ = for_game_;
	}
	else {
		the_instance->chn_srv_ip_ = ip_;
		the_instance->chn_srv_port_ = port_;
		the_instance->chn_srv_for_game_ = for_game_;
	}
	return error_noerror;
}

int msg_sync_item::handle_this()
{
	if (item_id_ == currency_koko_gold){
		the_instance->the_role_->gold_ = count_;
	}
	else if (item_id_ == currency_game_gold){
		the_instance->the_role_->gold_game_ = count_;
	}
	else if (item_id_ == currency_game_tickets)	{
		the_instance->the_role_->gold_free_ = count_;
	}
	else if (item_id_ == currency_game_gold_lock){
		the_instance->the_role_->gold_game_lock_ = count_;
    }	
    else if (item_id_ == currency_vip_value){
        the_instance->the_role_->vipValue_ = count_;
    }
    else if (item_id_ == currency_vip_limit){
        the_instance->the_role_->vipLimit_ = count_;
    }
	else{
	}
	return error_noerror;
}

static int ii= 0;
int msg_region_data::handle_this()
{
	return error_noerror;
}

int msg_srv_progress::handle_this()
{
	return error_noerror;
}

int msg_sync_token::handle_this()
{
	the_instance->srv_sn_ = sequence_;
	the_instance->srv_token_ = token_;
	return error_noerror;
}

int msg_173user_login_ret::handle_this()
{
	//如果是173用户,这里需要重新登录KOKO平台.
	
	return error_noerror;
}


int msg_get_bank_info_ret::handle_this()
{
	return error_noerror;
}

int msg_present_data::handle_this()
{
	return error_noerror;
}
/************************************************************************/
/* 自定义房间相关
/************************************************************************/
int msg_private_room_remove::handle_this()
{

	return error_noerror;
}

int msg_room_create_ret::handle_this()
{

	return error_noerror;
}

int msg_enter_private_room_ret::handle_this()
{
	return error_noerror;
}

int msg_private_room_players::handle_this()
{

	return error_noerror;
}

int msg_switch_game_server::handle_this()
{
	the_instance->game_srv_ip_ = ip_;
	the_instance->game_srv_port_ = port_;
	return error_noerror;
}

int msg_acc_info_invalid::handle_this()
{
    return error_noerror;
}

int msg_black_account::handle_this()
{
    return error_relogin;
}

int msg_user_head_and_headframe::handle_this()
{
    the_instance->the_role_->headIcon_ =head_ico_;
    the_instance->the_role_->headBack_ = QString::number(headframe_id_);

    return error_noerror;
}
