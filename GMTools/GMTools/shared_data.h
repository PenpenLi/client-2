#pragma once
#include <QString>
#include <vector>
#include <boost/shared_ptr.hpp>
#include <map>
#include "net_socket_native.h"

class msg_base;
//��Ϸ����࣬�����msg_player_info�������ͬ
struct koko_player
{
	QString		uID_;//���ȫ��ID
	QString		nickName_;//����ǳ�
	__int64		iID_;//��ҵ�����ID 
	QString		headIcon_;//ͷ��ͼ��
	__int64		gold_;//���
	__int64		gold_game_;
	__int64		gold_free_;
	__int64		gold_game_lock_;
	int			vipLevel_;//vip�ȼ�
	long		chanelID_;
	int			isagent_; //0 ����,1����,2����
	int			age_, gender_, byear_, bmonth_, bday_, mobile_v_, email_v_;
	QString		mobile_, email, idcard;
	int			region1_, region2_, region3_;
	QString		address_;
	std::vector<char>		screen_shoot_;
	int				is_bot_;
	int				is_newbee_;	//�����
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
	error_is_in_room,	//�Ѿ��ڷ�������
	error_cant_find_host,
	error_json_parse_error,
	error_routine_continue,
	error_noerror = 0,
};

enum
{
	srv_error_wrong_sign = -1000,	//����ǩ������
	srv_error_wrong_password,			//���벻��
	srv_error_sql_execute_error,	//sql���ִ��ʧ��
	srv_error_no_record,					//���ݿ���û����Ӧ��¼
	srv_error_user_banned,				//�û�����ֹ
	srv_error_account_exist,			//ע���˻����Ѵ���
	srv_error_server_busy,				//��������æ
	srv_error_cant_find_player,		//�Ҳ������
	srv_error_cant_find_match,
	srv_error_cant_find_server,
	srv_error_msg_ignored,
	srv_error_cancel_timer,
	srv_error_cannt_regist_more,  //������ע����
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
	client_type_check_account = 1,          //����˺� 
	client_type_check_name,                    //����ǳ�
	client_type_check_count_account,    //����û����Ƿ��ظ�
	client_type_check_count_name,      //����ǳ��Ƿ��ظ�
	client_type_post_1,                         //post ����
	client_type_web_gift_bag = 6,       //��ҳ���
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
	int		cat_;		//0��ͨ����,1-��������
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
	currency_koko_gold,		//ƽ̨����
	currency_game_gold,		//��Ϸ����
	currency_game_tickets,//Kȯ
	currency_game_gold_lock,//��Ϸ�������˶���Ǯ
	currency_gold_bank,
	currency_gold_game_bank,
	currency_exp_1,				//����ֵ
	currency_vip_value = 102,
	currency_vip_limit = 103,

};

struct end_point
{
	char	ip_[32];
	int		port_;
};

//ƽ̨����ʱ����������������Ϸ�������������ļ�
//�ͻ��˾����˴�������

//����������Ϣ
struct host_info
{
	__int64	roomid_;	//����ID
	char		roomname_[128];	//��������
	char		host_uid_[64]; //����ID
	char		thumbnail_[256]; //����ͼ
	end_point	addr_; //�����ַ
	end_point	game_addr_; //��Ϸ��������ַ
	int			gameid_;//������Ϸid
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

//��Ϸ������Ϣ��ƽ̨����ʱ��������
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
	int						id_;							//��Ϸid	
	int						type_;						//0 �ͻ�����Ϸ��1 flash��Ϸ
	char					dir_[64];					//Ŀ¼��ֻ������һ��Ŀ¼������������·��
	char					exe_[64];					//��ִ�г�����
	char					update_url_[128];	//����·��
	char					help_url_[128];		//����·��
	char					game_name_[128];	//��Ϸ����
	char					thumbnail_[128];	//����ͼ
	char					solution_[16];		//��Ϸ����Ʒֱ���
	int						no_embed_;			//1-��Ƕ��ƽ̨��ֱ������ 3-��Ƕ��ƽ̨, �򿪷����б�����, 0-Ƕ��ƽ̨���򿪷����б����У�2-Ƕ��ƽ̨��ֱ������, 
	char					catlog_[128];
	int						order_;
	game_info() { type_ = 0; }
};

//�����Ľ������ܶ�����ͬ����Ҫר��Ūһ����������ģ��������������
//����������ģ��ֻ������¼�������ݣ�����������
struct match_info
{
	int						id_;							//����id
	int						match_type_;			//�������� 0-��ʱ��, 1-���˴�����,2-��̭��
	int						game_id_;					//��Ϸid����Ӧgame_info����Ϸid
	char					match_name_[128];	//��������
	char					thumbnail_[128];	//����ͼ
	char					help_url_[128];		//��������	
	char					prize_desc_[256];	//��������
	int						start_type_;			//����ʱ��,0��ʱ����,1�������� 2�汨�濪
	int						require_count_;		//�����������Ҫ��
	int						start_stripe_;		//start_type_ = 0ʱ������ֶ���Ч, 0 ���ʱ�俪, 1 �̶�ʱ�俪
	int						end_type_;				//����ʱ�� 0��ʱ������1 ����ʤ��
	int						end_data_;				//���� end_type_ = 0, �����ǽ���ʱ��, = 1���Ǿ���ʤ����
	std::map<int, int>	costs_;
	char					ip_[64];
	int						port_;
	match_info() {};
};

struct game_room_inf
{
	int						game_id_;
	int						room_id_;						//>0xA0000000ʱ,���Զ��巿��id,�������볡��������id
	char					room_name_[64];
	char					room_desc_[64];
	char					ip_[32];
	int						port_;
	char					thumbnail_[128];			//����ͼ
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
