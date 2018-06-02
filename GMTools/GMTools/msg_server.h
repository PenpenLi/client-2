#pragma once

#include "msg.h"
#include "msg_client.h"
#include "json_helper.h"
#include "base64Con.h"
#include "shared_data.h"

enum 
{	
	GET_CLSID(msg_common_reply) = 1001,
	GET_CLSID(msg_user_login_ret) = 1000,
	GET_CLSID(msg_user_login_ret_game) = 1000,

	GET_CLSID(msg_player_info) = 1002,
	GET_CLSID(msg_player_leave),
	GET_CLSID(msg_chat_deliver),
	GET_CLSID(msg_same_account_login),
	GET_CLSID(msg_live_show_start),
	GET_CLSID(msg_turn_to_show),
	GET_CLSID(msg_host_apply_accept),
	GET_CLSID(msg_channel_server),
	GET_CLSID(msg_image_data) = 1010,
	GET_CLSID(msg_user_image),
	GET_CLSID(msg_account_info_update),
	GET_CLSID(msg_verify_code),
	GET_CLSID(msg_check_data_ret),
	GET_CLSID(msg_live_show_stop),
	GET_CLSID(msg_sync_item),
	GET_CLSID(msg_region_data),
	GET_CLSID(msg_srv_progress),
	GET_CLSID(msg_sync_token),
	GET_CLSID(msg_confirm_join_game_deliver),
	GET_CLSID(msg_173user_login_ret),
	GET_CLSID(msg_room_create_ret),
	GET_CLSID(msg_enter_private_room_ret),
	GET_CLSID(msg_get_bank_info_ret),
	GET_CLSID(msg_present_data),
	GET_CLSID(msg_private_room_remove),
	GET_CLSID(msg_private_room_players),
	GET_CLSID(msg_switch_game_server) = 1028,
    GET_CLSID(msg_acc_info_invalid) = 20025,
    GET_CLSID(msg_black_account) = 1056,
    GET_CLSID(msg_user_head_and_headframe) = 1040,
	GET_CLSID(msg_game_data) = 20011,
	GET_CLSID(msg_query_data_rsp) = 1206,
};

class		msg_player_info : public msg_base
{
public:
	char			uid_[max_guid];
	char			nickname_[max_name];
	__int64		iid_;
	__int64		gold_;
	int				vip_level_;
	int				channel_;	
	int				gender_;
	int				level_;
	int				isagent_;
	int				isinit_;
	msg_player_info()
	{
		head_.cmd_ = GET_CLSID(msg_player_info);
		channel_ = 0;
	}

	int			read(boost::property_tree::ptree& data_s)
	{
		msg_base::read(data_s);
		read_jstring(uid_, max_guid, data_s);
		read_jstring(nickname_, max_name, data_s);
		read_jvalue(iid_, data_s);
		read_jvalue(gold_, data_s);
		read_jvalue(vip_level_, data_s);
		read_jvalue(channel_, data_s);
		read_jvalue(gender_, data_s);
		read_jvalue(level_, data_s);
		read_jvalue(isagent_, data_s);
		read_jvalue(isinit_, data_s);
		return 0;
	}
	int			handle_this();
};

class		msg_user_login_ret : public msg_player_info
{
public:
	char			token_[max_guid];
	__int64		sequence_;

	char			email_[max_guid];		//email
	char			phone[32];					//手机号
	char			address_[256];			//地址
	__int64		game_gold_;					//游戏币
	__int64		game_gold_free_;
	int				email_verified_;		//邮箱地址已验证 0未验证，1已验证
	int				phone_verified_;		//手机号验已验证 0未验证，1已验证
	int				byear_, bmonth_, bday_;	//出生年月日
	int				region1_,region2_,region3_;
	int				age_;
	char			idcard_[32];				//身份证号
    char         app_key_[max_guid];
    char        party_name_[max_guid];
	msg_user_login_ret()
	{
		head_.cmd_ = GET_CLSID(msg_user_login_ret);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_player_info::read(data_s);
        read_jstring(token_, max_guid, data_s);
        read_jvalue(sequence_, data_s);
        read_jstring(email_, max_name, data_s);
        read_jstring(phone, 32, data_s);
        read_jstring(address_, 256, data_s);
        read_jvalue(game_gold_, data_s);
        read_jvalue(game_gold_free_, data_s);
        read_jvalue(email_verified_, data_s);
        read_jvalue(phone_verified_, data_s);
        read_jvalue(byear_, data_s);
        read_jvalue(bmonth_, data_s);
        read_jvalue(bday_, data_s);
        read_jvalue(region1_, data_s);
        read_jvalue(region2_, data_s);
        read_jvalue(region3_, data_s);
        read_jvalue(age_, data_s);
        read_jstring(idcard_, 32, data_s);
        read_jstring(app_key_, max_guid, data_s);
         read_jstring(party_name_, max_guid, data_s);
        return 0;
    }

	int			handle_this();
};

//更改用户数据
class msg_account_info_update : public msg_base
{
public:
	int		gender_;
	int		byear_;
	int		bmonth_;
	int		bday_;
	char	address_[256];
	char	nick_name_[64];	
	int		age_;
	char	mobile_[32];
	char	email_[32];
	char	idcard_[32];
	int		region1_, region2_,region3_;
	msg_account_info_update()
	{
		head_.cmd_ = GET_CLSID(msg_account_info_update);
		address_[0] = 0;
		mobile_[0] = 0;
		email_[0] = 0;
		idcard_[0] = 0;
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(gender_, data_s);
        read_jvalue(byear_, data_s);
        read_jvalue(bmonth_, data_s);
        read_jvalue(bday_, data_s);
        read_jstring(address_, 256, data_s);
        read_jstring(nick_name_, 64, data_s);
        read_jvalue(age_, data_s);
        read_jstring(mobile_, 32, data_s);
        read_jstring(email_, 32, data_s);
        read_jstring(idcard_, 32, data_s);
        read_jvalue(region1_, data_s);
        read_jvalue(region2_, data_s);
        read_jvalue(region3_, data_s);
        return 0;
    }
};


class		msg_player_leave : public msg_base
{
public:
	int				channel_;
	char			uid_[max_guid];
	msg_player_leave()
	{
		head_.cmd_ = GET_CLSID(msg_player_leave);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(channel_, data_s);
        read_jstring(uid_, max_guid, data_s);
        return 0;
    }

	int			handle_this();
};

class		msg_broadcast_base : public msg_base
{
public:
	int			msg_type_;		//0 聊天，1 密语，2 系统消息，4 广播 5,礼物广播

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(msg_type_, data_s);
        return 0;
    }

};

class		msg_chat_deliver : public msg_broadcast_base
{
public:
	int			channel_;
	int			from_tag_;			//发送方的标签 0正常玩家,1官方客服
	char		from_uid_[max_guid];
	char		nickname_[max_guid];
	int			to_tag_;				//接收方的标签
	char		to_uid_[max_guid];
	char		to_nickname_[max_guid];

	char		content_[512];
	msg_chat_deliver()
	{
		head_.cmd_ = GET_CLSID(msg_chat_deliver);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_broadcast_base::read(data_s);
        read_jvalue(channel_, data_s);
        read_jvalue(from_tag_, data_s);
        read_jstring(from_uid_, max_guid, data_s);
        read_jstring(nickname_, max_guid, data_s);

        read_jvalue(to_tag_, data_s);
        read_jstring(to_uid_, max_guid, data_s);
        read_jstring(to_nickname_, max_guid, data_s);

        read_jstring(content_, 512, data_s);

        return 0;
    }

	int			handle_this();
};

class		msg_same_account_login : public msg_base
{
public:
	msg_same_account_login()
	{
		head_.cmd_ = GET_CLSID(msg_same_account_login);
	}
	int			handle_this();
};

//通知客户端主播开始。
class msg_live_show_start : public msg_base
{
public:
	int		roomid_;
	char	hostid_[max_guid];
	msg_live_show_start()
	{
		head_.cmd_ = GET_CLSID(msg_live_show_start);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(roomid_, data_s);
        read_jstring(hostid_, max_guid, data_s);
        return 0;
    }

	int			handle_this();
};

class msg_live_show_stop : public msg_live_show_start
{
public:
	msg_live_show_stop()
	{
		head_.cmd_ = GET_CLSID(msg_live_show_stop);
	}
	int			handle_this();
};


//通知主播可以开播。
class msg_turn_to_show : public msg_base
{
public:
	int			roomid_;
	int			reply_;

	msg_turn_to_show()
	{
		head_.cmd_ = GET_CLSID(msg_turn_to_show);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(roomid_, data_s);
        read_jvalue(reply_, data_s);
        return 0;
    }

	int			handle_this();
};

//通知主播麦序被接受
class msg_host_apply_accept : public msg_player_info
{
public:

	msg_host_apply_accept()
	{
		head_.cmd_ = GET_CLSID(msg_host_apply_accept);
	}
	int			handle_this();
};

class msg_channel_server : public msg_base
{
public:
	char	ip_[max_name];
	int		port_;
	int		for_game_;
	msg_channel_server()
	{
		head_.cmd_ = GET_CLSID(msg_channel_server);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jstring(ip_, max_guid, data_s);
        read_jvalue(port_, data_s);
        read_jvalue(for_game_, data_s);
        return 0;
    }

	int			handle_this();
};

//图片数据传输
class msg_image_data : public msg_base
{
public:
	int		this_image_for_;		//> 0 avroomid, -1 个人头像, -2 验证码图片
	int	    TAG_;	//1开始，2，结束，0，中间
	int		len_;
	char	    data_[2048];
	msg_image_data()
	{
        head_.cmd_ = GET_CLSID(msg_image_data);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(this_image_for_, data_s);
        read_jvalue(TAG_, data_s);
        read_jvalue(len_, data_s);
        std::string  dat;
        read_jvalue(dat, data_s);
        std::string dat1 =  base64_decode(dat);
        len_ = dat1.size();
		memcpy(data_, dat1.c_str(), dat1.size());
        return 0;
    } 
};

//继承自msg_image_data
//用户图片,this_image_for_ 在这个类中的意义改变, 0-用户头像, ...（其它以后再定义)
class msg_user_image : public msg_image_data
{
public:
	char		uid_[max_guid];
	msg_user_image()
	{
		head_.cmd_ = GET_CLSID(msg_user_image);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_image_data::read(data_s);
        read_jstring(uid_, max_guid, data_s);
        return 0;
    }
};

//验证码问题
class msg_verify_code : public msg_base
{
public:
	char	question_[128];
	char	anwsers_[256];
	msg_verify_code()
	{
		head_.cmd_ = GET_CLSID(msg_verify_code);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jstring(question_, 128, data_s);
        read_jstring(anwsers_, 256, data_s);
        return 0;
    }

};

//数据检查结果返回
class msg_check_data_ret : public msg_base
{
public:
	int			query_type_;		//同msg_check_data中的query_type_
	int			result_;
	msg_check_data_ret()
	{
		head_.cmd_ = GET_CLSID(msg_check_data_ret);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(query_type_, data_s);
        read_jvalue(result_, data_s);
        return 0;
    }

};

class	msg_sync_item : public msg_base
{
public:
	int				item_id_;
	__int64		count_;
	msg_sync_item()
	{
		head_.cmd_ = GET_CLSID(msg_sync_item);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(item_id_, data_s);
        read_jvalue(count_, data_s);
        return 0;
    }

	int			handle_this();
};

class		msg_region_data : public msg_base
{
public:
	int			rid_;
	int			prid_;
	int			rtype_;
	int			pprid_;
	char		rname[max_name];

	msg_region_data()
	{
		head_.cmd_ = GET_CLSID(msg_region_data);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(rid_, data_s);
        read_jvalue(prid_, data_s);
        read_jvalue(rtype_, data_s);
        read_jstring(rname, max_name, data_s);
        read_jvalue(pprid_, data_s);
        return 0;
    }

	int			handle_this();
};

//服务器进度
class		msg_srv_progress : public msg_base
{
public:
	int		pro_type_;		//类型 0 登录进度
	int		step_;				//进度
	int		step_max_;		//进度最大值
	msg_srv_progress()
	{
		head_.cmd_ = GET_CLSID(msg_srv_progress);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(pro_type_, data_s);
        read_jvalue(step_, data_s);
        read_jvalue(step_max_, data_s);
        return 0;
    }

	int			handle_this();
};

class msg_sync_token : public msg_base
{
public:
	msg_sync_token()
	{
		head_.cmd_ = GET_CLSID(msg_sync_token);
	}

	__int64		sequence_;
	char			token_[max_guid];

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(sequence_, data_s);
        read_jstring(token_, max_guid, data_s);
        return 0;
    }

	int			handle_this();
};

//通知客户端比赛开始了
class msg_confirm_join_game_deliver : public msg_base
{
public:
	int		match_id_;
	char	ins_id_[max_guid];
	int		register_count_;
	char	ip_[max_guid];
	int		port_;
	msg_confirm_join_game_deliver()
	{
		head_.cmd_ = GET_CLSID(msg_confirm_join_game_deliver);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(match_id_, data_s);
        read_jstring(ins_id_, max_guid, data_s);
        read_jvalue(register_count_, data_s);
        read_jstring(ip_, max_guid, data_s);
        read_jvalue(port_, data_s);
        return 0;
    }

};

class msg_173user_login_ret : public  msg_base
{
public:
	char	usid[max_guid];
	char	ppinf[512];
	msg_173user_login_ret()
	{
		head_.cmd_ = GET_CLSID(msg_173user_login_ret);
		ppinf[0] = 0;
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jstring(usid, max_guid, data_s);
        read_jstring(ppinf, 512, data_s);
        return 0;
    }

	int			handle_this();
};

//保险箱信息回复
class	 msg_get_bank_info_ret :  public msg_base
{
public:
	__int64		bank_gold_;
	__int64		bank_gold_game_;
	int				psw_set_;
	msg_get_bank_info_ret()
	{
		head_.cmd_ = GET_CLSID(msg_get_bank_info_ret);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(bank_gold_, data_s);
        read_jvalue(bank_gold_game_, data_s);
        read_jvalue(psw_set_, data_s);
        return 0;
    }

	int			handle_this();
};

//礼物数据
class  msg_present_data : public msg_base
{
public:
	present_info inf;
	msg_present_data()
	{
		head_.cmd_ = GET_CLSID(msg_present_data);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        json_msg_helper:: read_value("pid_", inf.pid_, data_s);
        json_msg_helper:: read_value("cat_",inf.cat_, data_s);
        json_msg_helper:: read_arr_value("name_",inf.name_, max_guid, data_s);
        json_msg_helper:: read_arr_value("desc_",inf.desc_, 256, data_s);
        json_msg_helper:: read_arr_value("ico_",inf.ico_, max_guid, data_s);
        json_msg_helper:: read_value("tax_",inf.tax_, data_s);
        json_msg_helper:: read_value("price_",inf.price_, data_s);
        return 0;
    }

	int			handle_this();
};

/************************************************************************/
/* 自定义房间消息回复
/************************************************************************/
class		msg_room_create_ret : public msg_base
{
public:
	private_room_inf inf;
	msg_room_create_ret()
	{
		head_.cmd_ = GET_CLSID(msg_room_create_ret);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        json_msg_helper:: read_value("game_id_", inf.game_id_, data_s);
        json_msg_helper:: read_value("room_id_", inf.room_id_, data_s);
        json_msg_helper:: read_arr_value("room_name_", inf.room_name_, max_guid, data_s);
        json_msg_helper:: read_value("player_count_", inf.player_count_, data_s);
        json_msg_helper:: read_value("seats_", inf.seats_, data_s);
        json_msg_helper:: read_value("config_index_", inf.config_index_, data_s);
        json_msg_helper:: read_arr_value("ip_", inf.ip_, max_guid, data_s);
        json_msg_helper:: read_value("port_", inf.port_, data_s);
        json_msg_helper:: read_arr_value("master_", inf.master_, max_guid, data_s);
        json_msg_helper:: read_value("need_psw_", inf.need_psw_, data_s);
        json_msg_helper:: read_arr_value("room_desc_", inf.room_desc_, max_guid,  data_s);
        return 0;
    }

	int			handle_this();
};

class  msg_enter_private_room_ret : public msg_base
{
public:
	int		gameid_;
	int		roomid_;
	int		succ_;	//0不存在房间,1房间有空,2房间满了, 3 密码不正确
	msg_enter_private_room_ret()
	{
		head_.cmd_ = GET_CLSID(msg_enter_private_room_ret);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(gameid_, data_s);
        read_jvalue(roomid_, data_s);
        read_jvalue(succ_, data_s);
        return 0;
    }

	int			handle_this();
};

class		msg_private_room_remove : public msg_base
{
public:
	int		gameid_;
	int		roomid_;
	msg_private_room_remove()
	{
		head_.cmd_ = GET_CLSID(msg_private_room_remove);
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(gameid_, data_s);
        read_jvalue(roomid_, data_s);
        return 0;
    }

	int			handle_this();
};

class		msg_private_room_players : public msg_base
{
public:
	int		roomid_;
	char	players_[8][max_guid];
	int		data1_[8];
	int		data2_[8];
	msg_private_room_players()
	{
		head_.cmd_ = GET_CLSID(msg_private_room_players);

		for (int i = 0; i < 8; i++)
		{
			memset(players_[i], 0, max_guid);
		}
	}

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(roomid_, data_s);
        for (int i = 0; i < 8; i++)
        {
            read_jstring(players_[i], max_guid, data_s);
        }
        read_jarr(data1_,  8, data_s);
        read_jarr(data2_,  8, data_s);
        return 0;
    }

	int			handle_this();
};

class	msg_switch_game_server : public msg_base
{
public:
	char	ip_[max_guid];
	int		port_;
	msg_switch_game_server()
	{
		head_.cmd_ = GET_CLSID(msg_switch_game_server);
	}

	int			read(boost::property_tree::ptree& data_s)
	{
		msg_base::read(data_s);
		read_jstring(ip_, max_guid, data_s);
		read_jvalue(port_, data_s);
		return 0;
	}
	int			handle_this();
};

class msg_acc_info_invalid : public msg_base
{
    int         type_;
public:
    msg_acc_info_invalid()
    {
        head_.cmd_ = GET_CLSID(msg_acc_info_invalid);
    }

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jvalue(type_, data_s);
        return 0;
    }

   int             handle_this();
};
//黑名单用户登录
class		msg_black_account : public msg_base
{
public:
    msg_black_account()
    {
        head_.cmd_ = GET_CLSID(msg_black_account);
    }
    int			handle_this();
};

class msg_user_head_and_headframe:public msg_base
{
public:
    char        head_ico_[max_guid];
    int           headframe_id_;

    msg_user_head_and_headframe()
    {
        head_.cmd_ = GET_CLSID(msg_user_head_and_headframe);
    }

    int			read(boost::property_tree::ptree& data_s)
    {
        msg_base::read(data_s);
        read_jstring(head_ico_, max_guid, data_s);
        read_jvalue(headframe_id_, data_s);
        return 0;
    }
    int handle_this();
};

class	msg_game_data : public msg_base
{
public:
	game_info		inf;
	msg_game_data()
	{
		head_.cmd_ = GET_CLSID(msg_game_data);
	}

	int			read(boost::property_tree::ptree& data_s)
	{
		msg_base::read(data_s);
		json_msg_helper::read_value("id_", inf.id_, data_s);
		json_msg_helper::read_value("type_", inf.type_, data_s);
		json_msg_helper::read_arr_value("dir_", inf.dir_, max_guid, data_s);
		json_msg_helper::read_arr_value("exe_", inf.exe_, max_guid, data_s);
		json_msg_helper::read_arr_value("update_url_", inf.update_url_, 128, data_s);
		json_msg_helper::read_arr_value("help_url_", inf.help_url_, 128, data_s);
		json_msg_helper::read_arr_value("game_name_", inf.game_name_, 128, data_s);
		json_msg_helper::read_arr_value("thumbnail_", inf.thumbnail_, 128, data_s);
		json_msg_helper::read_arr_value("solution_", inf.solution_, 16, data_s);
		json_msg_helper::read_value("no_embed_", inf.no_embed_, data_s);
		json_msg_helper::read_arr_value("catlog_", inf.catlog_, 128, data_s);
		json_msg_helper::read_value("order_", inf.order_, data_s);
		return 0;
	}

	int					handle_this();
};


class msg_user_login_ret_game :public msg_base
{
public:
	int				iid_;
	int				lv_;
	double			currency_;
	double			exp_;
	double			exp_max_;
	std::string		uname_;
	std::string		uid_;
	std::string		head_pic_;
	msg_user_login_ret_game()
	{
		head_.cmd_ = GET_CLSID(msg_user_login_ret_game);
	}

	int			write(boost::property_tree::ptree& data_s)
	{
		msg_base::write(data_s);
		write_jvalue(iid_, data_s);
		write_jvalue(lv_, data_s);
		write_jvalue(currency_, data_s);
		write_jvalue(exp_, data_s);
		write_jvalue(exp_max_, data_s);
		write_jvalue(uname_, data_s);
		write_jvalue(uid_, data_s);
		write_jvalue(head_pic_, data_s);
		return 0;
	}
};

//响应数据
class msg_query_data_rsp : public msg_base
{
public:
	std::string data_;
	msg_query_data_rsp()
	{
		head_.cmd_ = GET_CLSID(msg_query_data_rsp);
	}
	int			read(boost::property_tree::ptree& data_s)
	{
		msg_base::read(data_s);
		read_jvalue(data_, data_s);
		return error_noerror;
	}
};