#pragma once
#include <QString>
#include <vector>
#include <boost/shared_ptr.hpp>
#include <map>
#include "net_socket_native.h"

class msg_base;
//游戏玩家类，与接收msg_player_info类基本相同
struct koko_player
{
	QString		uID_;//玩家全局ID
	QString		nickName_;//玩家昵称
	__int64		iID_;//玩家的数字ID 
	QString		headIcon_;//头像图标
	__int64		gold_;//金币
	__int64		gold_game_;
	__int64		gold_free_;
	__int64		gold_game_lock_;
	int			vipLevel_;//vip等级
	long		chanelID_;
	int			isagent_; //0 不是,1销售,2银商
	int			age_, gender_, byear_, bmonth_, bday_, mobile_v_, email_v_;
	QString		mobile_, email, idcard;
	int			region1_, region2_, region3_;
	QString		address_;
	std::vector<char>		screen_shoot_;
	int				is_bot_;
	int				is_newbee_;	//新玩家
	QString        appkey_;
	QString        headBack_;
	int                vipValue_;
	int                vipLimit_;
	QString        part_name;
	int               is_tourist;
	koko_player()
	{
		chanelID_ = -1;
		gold_ = 0;
		vipLevel_ = 0;
		gold_game_ = 0;
		age_ = gender_ = bmonth_ = bday_ = byear_ = 0;
		region1_ = region2_ = region3_ = 0;
		gold_game_lock_ = 0;
		is_bot_ = 0;
		vipValue_ = vipLimit_ = 0;
		is_tourist = 0;
	}
};

enum
{
	error_game_not_find = -1000,
	error_dont_care,
	error_is_downloading,
	error_need_restart,
	error_relogin,
	error_is_in_room,	//已经在房间里了
	error_cant_find_host,
	error_json_parse_error,
	error_routine_continue,
	error_noerror = 0,
};

enum
{
	srv_error_wrong_sign = -1000,	//数字签名不对
	srv_error_wrong_password,			//密码不对
	srv_error_sql_execute_error,	//sql语句执行失败
	srv_error_no_record,					//数据库中没有相应记录
	srv_error_user_banned,				//用户被禁止
	srv_error_account_exist,			//注册账户名已存在
	srv_error_server_busy,				//服务器正忙
	srv_error_cant_find_player,		//找不到玩家
	srv_error_cant_find_match,
	srv_error_cant_find_server,
	srv_error_msg_ignored,
	srv_error_cancel_timer,
	srv_error_cannt_regist_more,  //不能再注册了
	srv_error_email_inusing,
	srv_error_mobile_inusing,
	srv_error_wrong_verify_code,
	srv_error_time_expired,
	srv_error_invalid_data,
	srv_error_success = 0,
	srv_error_business_handled,
	srv_error_invalid_request,
	srv_error_not_enough_gold,
	srv_error_not_enough_gold_game,
	srv_error_not_enough_gold_free,
	srv_error_cant_find_coordinate,
	srv_error_no_173_account,
	srv_error_no_173_pretty,
};

enum
{
	client_action_user_online,

	client_action_login_timecost = 2,

	client_action_login_open,
	client_action_register_open,
	client_action_register_send,
	client_action_user_game_online = 1000,
};
enum
{
	client_type_check_account = 1,          //检查账号 
	client_type_check_name,                    //检查昵称
	client_type_check_count_account,    //检查用户名是否重复
	client_type_check_count_name,      //检查昵称是否重复
	client_type_post_1,                         //post 请求
	client_type_web_gift_bag = 6,       //网页礼包
	client_type_get_appkey,
	client_type_update_page,
	clent_type_share_imgurl,
	client_type_web_phone_login,
	client_type_web_avatar,
	client_type_web_my_avatar,
	clinet_type_web_avatar_list,
	client_type_web_update_reward,
	client_err_nickname_length = -1000,
	client_err_nickname_content,
};

struct	present_info
{
	int		pid_;
	int		cat_;		//0普通礼物,1-银商礼物
	char	name_[64];
	char	desc_[256];
	char	ico_[64];
	int		tax_;
	int		price_;
	int		mycount_;
	present_info()
	{
		mycount_ = 0;
		price_ = 0;
		tax_ = 0;
		cat_ = 0;
		pid_ = 0;
	}
};

enum
{
	currency_koko_gold,		//平台货币
	currency_game_gold,		//游戏货币
	currency_game_tickets,//K券
	currency_game_gold_lock,//游戏币锁定了多少钱
	currency_gold_bank,
	currency_gold_game_bank,
	currency_exp_1,				//经验值
	currency_vip_value = 102,
	currency_vip_limit = 103,

};

struct end_point
{
	char	ip_[32];
	int		port_;
};

//平台启动时，会下载主播，游戏，比赛的配置文件
//客户端就有了处理依据

//主播配置信息
struct host_info
{
	__int64	roomid_;	//房间ID
	char		roomname_[128];	//房间名称
	char		host_uid_[64]; //主播ID
	char		thumbnail_[256]; //缩略图
	end_point	addr_; //网络地址
	end_point	game_addr_; //游戏服务器地址
	int			gameid_;//关联游戏id
	int			popular_;
	int			online_players_;
	int			is_online_;
	int			avshow_start_;
	std::string tag, tag_color;
	host_info();
};

struct host_info_ex : public host_info
{
	std::vector<char>		screen_shoot_;
};

//游戏配置信息，平台启动时，会下载
struct game_info
{
	enum
	{
		game_cat_classic,
		game_cat_match,
		game_cat_host,
	};
	enum
	{

	};
	int						id_;							//游戏id	
	int						type_;						//0 客户端游戏，1 flash游戏
	char					dir_[64];					//目录，只允许填一个目录名，不允许填路径
	char					exe_[64];					//可执行程序名
	char					update_url_[128];	//更新路径
	char					help_url_[128];		//介绍路径
	char					game_name_[128];	//游戏名称
	char					thumbnail_[128];	//略缩图
	char					solution_[16];		//游戏的设计分辨率
	int						no_embed_;			//1-不嵌入平台，直接运行 3-不嵌入平台, 打开房间列表运行, 0-嵌入平台，打开房间列表运行，2-嵌入平台，直接运行, 
	char					catlog_[128];
	int						order_;
	game_info() { type_ = 0; }
};

//比赛的奖励可能都不相同，需要专门弄一个比赛奖励模块来处理奖励问题
//比赛服务器模块只处理，记录比赛数据，不负责奖励。
struct match_info
{
	int						id_;							//比赛id
	int						match_type_;			//比赛类型 0-定时赛, 1-个人闯关赛,2-淘汰赛
	int						game_id_;					//游戏id，对应game_info的游戏id
	char					match_name_[128];	//比赛名称
	char					thumbnail_[128];	//缩略图
	char					help_url_[128];		//比赛介绍	
	char					prize_desc_[256];	//奖励描述
	int						start_type_;			//开赛时机,0按时开赛,1人满即开 2随报随开
	int						require_count_;		//开赛最低人数要求
	int						start_stripe_;		//start_type_ = 0时，这个字段有效, 0 间隔时间开, 1 固定时间开
	int						end_type_;				//结束时机 0定时结束，1 决出胜者
	int						end_data_;				//数据 end_type_ = 0, 这里是结束时长, = 1，是决出胜者数
	std::map<int, int>	costs_;
	char					ip_[64];
	int						port_;
	match_info() {};
};

struct game_room_inf
{
	int						game_id_;
	int						room_id_;						//>0xA0000000时,是自定义房间id,否则是入场配置限制id
	char					room_name_[64];
	char					room_desc_[64];
	char					ip_[32];
	int						port_;
	char					thumbnail_[128];			//缩略图
	char					require_[256];
	game_room_inf()
	{
		memset(this, 0, sizeof(*this));
	}
};

struct private_room_inf : public game_room_inf
{
	int						config_index_;
	std::string		config_desc_;
	int						need_psw_;
	int						player_count_;
	int						seats_;
	char					master_[64];
};
typedef boost::shared_ptr<game_info> gamei_ptr;

class		user_connector : public native_socket
{
public:
	user_connector(boost::asio::io_service& ios) :native_socket(ios)
	{

	}
	void close(bool passive = false) override;
};

class GMTools;
class main_controller
{
public:
	main_controller();
	~main_controller();
	
	QString srv_token_;
	__int64 srv_sn_;

	std::string chn_srv_ip_;
	int			chn_srv_port_;
	int			chn_srv_for_game_;

	std::map<int, gamei_ptr> all_games;
	std::string game_srv_ip_;
	int			game_srv_port_;
	GMTools*	mainw_;
	boost::shared_ptr<koko_player> the_role_;
	boost::shared_ptr<user_connector> center_connector_,
		channel_connector_,
		game_connector_;

	static  main_controller * get_instance();
	static	void	free_instance();

	void		stop();
	int			step();

	int			connect_to_acc(std::string ip, int port);
	int			connect_to_channel();
	int			connect_to_game();


	void		net_login_to_acc(std::string uname, std::string psw);
	void		net_get_channel(int gameid);
	void		net_login_to_channel();

	void		net_get_gameserver(int gameid);
	void		net_login_to_game();
	void		net_send_cmd(std::string param);
private:
	boost::asio::io_service ios_;

	void		handle_msgs();

	int			send_msg_to_acc(msg_base& msg);
	int			send_msg_to_channel(msg_base& msg);
	int			send_msg_to_game(msg_base& msg);
};
