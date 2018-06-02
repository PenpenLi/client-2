#pragma once
#include "msg.h"
#include "msg_from_client.h"
#include "json_helper.h"

enum
{
	GET_CLSID(msg_mobile_login) = 99,
	GET_CLSID(msg_user_login) = 100,
	GET_CLSID(msg_user_register) = 101,
	GET_CLSID(msg_join_channel) = 102,
	GET_CLSID(msg_chat)= 103,
	GET_CLSID(msg_leave_channel)= 104,
	GET_CLSID(msg_host_apply)= 105,
	GET_CLSID(msg_show_start)= 106,
	GET_CLSID(msg_user_login_channel)= 107,
	GET_CLSID(msg_upload_screenshoot)= 108,
	GET_CLSID(msg_show_stop)= 109,
	GET_CLSID(msg_change_account_info) = 110,
	GET_CLSID(msg_get_verify_code) = 111,
	GET_CLSID(msg_check_data) = 112,
	GET_CLSID(msg_user_login_delegate) = 113,	//占位
	GET_CLSID(msg_send_present) = 114,
	GET_CLSID(msg_get_token) = 115,
	GET_CLSID(msg_action_record) = 116,
	GET_CLSID(msg_get_game_coordinate) =117,
	GET_CLSID(msg_173user_login) = 118,
	GET_CLSID(msg_create_private_room) = 119,
	GET_CLSID(msg_enter_private_room)= 120,
	GET_CLSID(msg_send_live_present) = 121,
	GET_CLSID(msg_get_bank_info) = 122,
	GET_CLSID(msg_set_bank_psw) = 123,
	GET_CLSID(msg_bank_op) = 124,
	GET_CLSID(msg_trade_173_gold),
	GET_CLSID(msg_transfer_gold_to_game),
	GET_CLSID(msg_get_private_room_list),
	GET_CLSID(msg_buy_item),
    GET_CLSID(msg_token_login) = 130,
    GET_CLSID(msg_scan_qrcode) = 1029,
	GET_CLSID(msg_alloc_game_server) = 1030,
    GET_CLSID(msg_modify_acc_name) = 1035,
    GET_CLSID(msg_modify_nick_name) = 1036,
    GET_CLSID(msg_set_head_and_headframe) = 1042,
	GET_CLSID(msg_platform_login_req) = 994,
};

class no_socket{};

class		msg_get_token : public msg_authrized
{
public:
	msg_get_token()
	{
		head_.cmd_ = GET_CLSID(msg_get_token);
	}
};

//登录
class msg_user_login : public msg_from_client
{
public:
	std::string		acc_name_;
	std::string		pwd_hash_;
	std::string		machine_mark_;

	msg_user_login()
	{
		head_.cmd_ = GET_CLSID(msg_user_login);
	}

	int			write(boost::property_tree::ptree& data_s)
	{
		msg_from_client::write(data_s);
		write_jvalue(acc_name_, data_s);
		write_jvalue(pwd_hash_, data_s);
		write_jvalue(machine_mark_, data_s);
		return 0;
	}
};

//173用户登录
class msg_173user_login : public msg_user_login
{
public:
	int		ispretty_;
	int		auto_register_;
	msg_173user_login()
	{
		head_.cmd_ = GET_CLSID(msg_173user_login);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_user_login::write(data_s);
        write_jvalue(ispretty_, data_s);
        write_jvalue(auto_register_, data_s);
        return 0;
    }

};

class	msg_mobile_login : public msg_user_login
{
public:
	char		dev_type[max_guid];
	msg_mobile_login()
	{
		head_.cmd_ = GET_CLSID(msg_mobile_login); //99
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_user_login::write(data_s);
        write_jvalue(dev_type, data_s);
        return 0;
    }

};


//登录游戏协同服务器
class msg_user_login_channel : public msg_from_client
{
public:
	std::string	uid_;
	__int64		sn_;
	std::string	token_;
	std::string device_;
	msg_user_login_channel()
	{
		head_.cmd_ = GET_CLSID(msg_user_login_channel);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_from_client::write(data_s);
        write_jvalue(uid_, data_s);
        write_jvalue(sn_, data_s);
        write_jvalue(token_, data_s);
		write_jvalue(device_, data_s);
        return 0;
    }
    
};

//注册账号
class msg_user_register : public msg_user_login
{
public:
	int		type_;	//0用户名,1手机，2邮箱
	char	verify_code[64];
	char	spread_from_[64];
	msg_user_register()
	{
		head_.cmd_ = GET_CLSID(msg_user_register);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_user_login::write(data_s);
        write_jvalue(type_, data_s);
        write_jvalue(verify_code, data_s);
        write_jvalue(spread_from_, data_s);
        return 0;
    }

};

class msg_join_channel : public msg_authrized
{
public:
	int			channel_;
	int			sn_;
	msg_join_channel()
	{
		head_.cmd_ = GET_CLSID(msg_join_channel);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(channel_, data_s);
        write_jvalue(sn_, data_s);
        return 0;
    }

};

class msg_leave_channel : public msg_join_channel
{
public:
	msg_leave_channel()
	{
		head_.cmd_ = GET_CLSID(msg_leave_channel);
	}
};

class	msg_chat : public msg_authrized
{
public:
	int			channel_;			//频道id
	char		to_[max_guid];		//密语对象,不是密语则为空
	char		content_[512];		//内容
	msg_chat()
	{
		head_.cmd_ = GET_CLSID(msg_chat);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(channel_, data_s);
        write_jvalue(to_, data_s);
        write_jvalue(content_, data_s);
        return 0;
    }

};


class msg_host_apply : public msg_authrized
{
public:
	int			channel_;					//频道id
	msg_host_apply()
	{
		head_.cmd_ = GET_CLSID(msg_host_apply);
	}
    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(channel_, data_s);
        return 0;
    }

};

class msg_show_start : public msg_authrized
{
public:
	int			channel_;					//频道id
	msg_show_start()
	{
		head_.cmd_ = GET_CLSID(msg_show_start);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(channel_, data_s);
        return 0;
    }

};

class	msg_show_stop : public msg_show_start
{
public:
	msg_show_stop()
	{
		head_.cmd_ = GET_CLSID(msg_show_stop);
	}
};

//更改用户数据
class msg_change_account_info : public msg_authrized
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
	msg_change_account_info()
	{
		head_.cmd_ = GET_CLSID(msg_change_account_info);
		address_[0] = 0;
		mobile_[0] = 0;
		email_[0] = 0;
		idcard_[0] = 0;
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(gender_, data_s);
        write_jvalue(byear_, data_s);
        write_jvalue(bmonth_, data_s);
        write_jvalue(bday_, data_s);
        write_jvalue(address_, data_s); 
        write_jvalue(nick_name_, data_s);
        write_jvalue(age_, data_s);
        write_jvalue(mobile_, data_s);
        write_jvalue(email_, data_s);
        write_jvalue(idcard_, data_s);
        write_jvalue(region1_, data_s);
        write_jvalue(region2_, data_s);
        write_jvalue(region3_, data_s);
        return 0;
    }

};

//生成验证码
class	msg_get_verify_code : public msg_from_client
{
public:
	int			type_;		//0图片验证码 1手机验证码 2 邮箱验证码
	char		mobile_[256];
	msg_get_verify_code()
	{
		head_.cmd_ = GET_CLSID(msg_get_verify_code);
		type_ = 0;
		mobile_[0] = 0;
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_from_client::write(data_s);
        write_jvalue(type_, data_s);
        write_jvalue(mobile_, data_s);
        return 0;
    }

};


class	 msg_check_data : public msg_from_client
{
public:
	enum 
	{
		check_account_name_exist,
		check_email_exist,
		check_mobile_exist,
		check_verify_code,	//图片验证码
		check_mverify_code,	//手机短信验证码
	};

	int					query_type_;
	__int64			query_idata_;	
	char				query_sdata_[64];
	msg_check_data()
	{
		head_.cmd_ = GET_CLSID(msg_check_data);
		query_sdata_[0] = 0;
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_from_client::write(data_s);
        write_jvalue(query_type_, data_s);
        write_jvalue(query_idata_, data_s);
        write_jvalue(query_sdata_, data_s);
        return 0;
    }

};

class		msg_action_record : public msg_from_client
{
public:
	int		action_id_;
	int		action_data_;		//是不离开游戏
	int		action_data2_;
	char	action_data3_[max_guid];
	msg_action_record()
	{
		head_.cmd_ = GET_CLSID(msg_action_record);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_from_client::write(data_s);
        write_jvalue(action_id_, data_s);
        write_jvalue(action_data_, data_s);
        write_jvalue(action_data2_, data_s);
        write_jvalue(action_data3_, data_s);
        return 0;
    }

};

//得到游戏协同服务器
class		msg_get_game_coordinate : public msg_from_client
{
public:
	int		gameid_;
	msg_get_game_coordinate()
	{
		head_.cmd_ = GET_CLSID(msg_get_game_coordinate);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_from_client::write(data_s);
        write_jvalue(gameid_, data_s);
        return 0;
    }

};

class		msg_send_live_present : public msg_authrized
{
public:
	char	roomid[max_guid];
	char	usid[max_guid];
	char	to[max_guid];
	char	giftid[max_guid];
	int		count;
	int		ismygift;
	msg_send_live_present()
	{
		head_.cmd_ = GET_CLSID(msg_send_live_present);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(roomid, data_s);
        write_jvalue(usid, data_s);
        write_jvalue(giftid, data_s);
        write_jvalue(count, data_s);
         write_jvalue(ismygift, data_s);
        return 0;
    }

};

//
class		msg_get_bank_info : public msg_authrized
{
public:
	msg_get_bank_info()
	{
		head_.cmd_ = GET_CLSID(msg_get_bank_info);
	}
};

//设置保险箱密码
class		msg_set_bank_psw : public msg_authrized
{
public:
	int				func_;	//0-设置密码, 1-修改密码, 2-验证密码
	char			old_psw_[32];
	char			psw_[32];
	msg_set_bank_psw()
	{
		head_.cmd_ = GET_CLSID(msg_set_bank_psw);
		memset(old_psw_, 0, 32);
		memset(psw_, 0, 32);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(func_, data_s);
        write_jvalue(old_psw_, data_s);
        write_jvalue(psw_, data_s);
        return 0;
    }

};

class		msg_bank_op : public msg_authrized
{
public:
	char		psw_[32];	//密码
	short		op_;			//0,提取,1存入
	short		type_;		//0,钻石,1K豆
	__int64			count_;	

	msg_bank_op()
	{
		head_.cmd_ = GET_CLSID(msg_bank_op);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(psw_, data_s);
        write_jvalue(op_, data_s);
        write_jvalue(type_, data_s);
        write_jvalue(count_, data_s);
        return 0;
    }

};

//173账号里的欢乐豆转成钻石
class		msg_trade_173_gold : public msg_authrized
{
public:
	char	master_id_[max_guid];
	msg_trade_173_gold()
	{
		head_.cmd_ = GET_CLSID(msg_trade_173_gold);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(master_id_, data_s);
        return 0;
    }

};

//钻石购买成K豆
class	 msg_transfer_gold_to_game : public msg_authrized
{
public:
	__int64 count_;

	msg_transfer_gold_to_game()
	{
		head_.cmd_ = GET_CLSID(msg_transfer_gold_to_game);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(count_, data_s);
        return 0;
    }

};

class	msg_send_present : public msg_authrized
{
public:
	int		channel_;
	int		present_id_;
	int		count_;
	char	to_[max_guid];
	msg_send_present()
	{
		head_.cmd_ = GET_CLSID(msg_send_present);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(channel_, data_s);
        write_jvalue(present_id_, data_s);
        write_jvalue(count_, data_s);
        write_jvalue(to_, data_s);
        return 0;
    }

};

/************************************************************************/
/* 自定义房间消息
/************************************************************************/
class		msg_create_private_room : public msg_authrized
{
public:
	int				roomid_;			//-1表示创建房间, >0表示修改这个房间
	int				config_index_;
	char			pws_[32];
	int				gameid_;
	char			title_[64];
	msg_create_private_room()
	{
		head_.cmd_ = GET_CLSID(msg_create_private_room);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(roomid_, data_s);
        write_jvalue(config_index_, data_s);
        write_jvalue(pws_, data_s);
        write_jvalue(gameid_, data_s);
        write_jvalue(title_, data_s);
        return 0;
    }

};

class		msg_enter_private_room : public msg_authrized
{
public:
	int				gameid_;
	int				roomid_;
	char			psw_[32];
	msg_enter_private_room()
	{
		head_.cmd_ = GET_CLSID(msg_enter_private_room);
		psw_[0] = 0;
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(gameid_, data_s);
        write_jvalue(roomid_, data_s);
        write_jvalue(psw_, data_s);
        return 0;
    }

};

class		msg_get_private_room_list : public msg_authrized
{
public:
	int				game_id_;
	msg_get_private_room_list()
	{
		head_.cmd_ = GET_CLSID(msg_get_private_room_list);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(game_id_, data_s);
        return 0;
    }

};

class		msg_buy_item : public  msg_authrized
{
public:
	int		item_id_;
	int		item_count_;
	msg_buy_item()
	{
		head_.cmd_ = GET_CLSID(msg_buy_item);
	}

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(item_id_, data_s);
        write_jvalue(item_count_, data_s);
        return 0;
    }

};

class	msg_scan_qrcode : public msg_from_client
{
public:
    char		clientid_[max_guid];
    char		passcode_[max_guid];
    msg_scan_qrcode()
    {
        head_.cmd_ = GET_CLSID(msg_scan_qrcode);
    }

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_from_client::write(data_s);
        write_jvalue(clientid_, data_s);
        write_jvalue(passcode_, data_s);
        return 0;
    }
};

class		msg_alloc_game_server : public msg_get_private_room_list
{
public:
	msg_alloc_game_server()
	{
		head_.cmd_ = GET_CLSID(msg_alloc_game_server);
	}
};

class     msg_modify_acc_name : public msg_user_login
{
public:
    char      uid_[max_guid];
    char		pwd_hash_[max_guid];
    char		new_acc_name_[max_guid];

    msg_modify_acc_name()
    {
        head_.cmd_ = GET_CLSID(msg_modify_acc_name);
    }

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_from_client::write(data_s);
        write_jvalue(uid_, data_s);
        write_jvalue(pwd_hash_, data_s);
        write_jvalue(new_acc_name_, data_s);
        return 0;
    }
};

class msg_modify_nick_name : public msg_authrized
{
public:
    char        uid_[max_guid];
    char        nick_name_[max_guid];

    msg_modify_nick_name()
    {
        head_.cmd_ = GET_CLSID(msg_modify_nick_name);
    }

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_from_client::write(data_s);
        write_jvalue(uid_, data_s);
        write_jvalue(nick_name_, data_s);
        return 0;
    }
};

class msg_set_head_and_headframe : public msg_authrized
{
public:
    char        head_ico_[max_guid];
    int           headframe_id_;

    msg_set_head_and_headframe()
    {
        head_.cmd_ = GET_CLSID(msg_set_head_and_headframe);
    }

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_authrized::write(data_s);
        write_jvalue(head_ico_, data_s);
        write_jvalue(headframe_id_, data_s);
        return 0;
    }
};

//使用token 登录世界服务器 主要用于重连
class msg_token_login : public msg_from_client
{
public:
    char		uid_[max_guid];
    __int64		sn_;
    char		token_[max_guid];
    std::string device_;
    msg_token_login()
    {
        head_.cmd_ = GET_CLSID(msg_token_login);
    }

    int			write(boost::property_tree::ptree& data_s)
    {
        msg_from_client::write(data_s);
        write_jvalue(uid_, data_s);
        write_jvalue(sn_, data_s);
        write_jvalue(token_, data_s);
        write_jvalue(device_, data_s);
        return 0;
    }
};

class msg_platform_login_req : public msg_from_client
{
public:
	std::string		uid_;
	std::string		uname_;
	int				vip_lv_;
	std::string		head_ico_;
	int				headframe_id_;	//头像框
	std::string		platform_;//php用到
	std::string		sn_;
	std::string		url_sign_;
	int				iid_;
	msg_platform_login_req()
	{
		head_.cmd_ = GET_CLSID(msg_platform_login_req);
		iid_ = 0;
	}

	int			write(boost::property_tree::ptree& data_s)
	{
		msg_from_client::write(data_s);
		write_jvalue(uid_, data_s);
		write_jvalue(uname_, data_s);
		write_jvalue(vip_lv_, data_s);
		write_jvalue(head_ico_, data_s);
		write_jvalue(headframe_id_, data_s);
		write_jvalue(platform_, data_s);
		write_jvalue(sn_, data_s);
		write_jvalue(url_sign_, data_s);
		write_jvalue(iid_, data_s);
		return 0;
	}
};
class msg_query_data_req : public msg_from_client
{
public:
	std::string cmd_;
	std::string params_;

	msg_query_data_req()
	{
		head_.cmd_ = 1205;
	}

	int			write(boost::property_tree::ptree& data_s)
	{
		msg_base::write(data_s);
		write_jvalue(cmd_, data_s);
		write_jvalue(params_, data_s);
		return 0;
	}
};
