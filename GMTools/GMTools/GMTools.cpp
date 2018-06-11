#include "GMTools.h"
#include "ui_GMTools.h"
#include "msg_server.h"
#include "msg_client.h"
#include "shared_data.h"
#include "QTimer"
#include "utility.h"
#include "msg_client.h"

extern main_controller* the_instance;

GMTools::GMTools(QWidget *parent)
	: QDialog(parent)
{
	state_ = 0;
	auto_set_times_ = 1;
	maxset_ = 1;

	ui = new Ui::GMToolsClass();
	ui->setupUi(this);
	QTimer::singleShot(20, this, SLOT(step()));

	connect(ui->btn_logingame, SIGNAL(clicked()), this, SLOT(on_logingame()));
	connect(ui->btn_sendcmd, SIGNAL(clicked()), this, SLOT(on_sendcmd()));
	connect(ui->btn_reset, SIGNAL(clicked()), this, SLOT(on_reset()));
	ui->cmb_functions->clear();

	ui->cmb_functions->addItem("Dynamic Set User Stock", 1);
	ui->cmb_functions->addItem("Disable User Stock", 2);
	ui->cmb_functions->addItem("Query System Balance", 3);
}

GMTools::~GMTools()
{
	delete ui;
}

void GMTools::step()
{
	QTimer::singleShot(20, this, SLOT(step()));

	main_controller::get_instance()->step();
}

void GMTools::auto_set()
{
	if (auto_set_times_ >= maxset_) return;
	write_log("auto set times:" + lx2s(auto_set_times_));
	do_send_cmd();
	auto_set_times_++;
	schedule_for_next();
}

void GMTools::on_logingame()
{
	int	gameid = ui->cmb_allgame->currentData(Qt::UserRole).toInt();
	if (state_ == 0) {
		write_log("is login to game...");

		std::string str = ui->edt_addr->text().toUtf8();

		std::string uname = ui->edt_accname->text().toUtf8();
		std::string psw = ui->edt_psw->text().toUtf8();

		std::vector<std::string> vip;
		split_str<std::string>(str, ":", vip, false);
		if (vip.size() != 2) {
			write_log("svr address format->IP:PORT");
			return;
		}

		int ret = the_instance->connect_to_acc(vip[0], s2i<int>(vip[1]));
		if (ret != 0) {
			write_log("can not connect to svr.");
			return;
		}
		write_log("account server connected, login to account.");
		the_instance->net_login_to_acc(uname, psw);
	}
	else if(state_ == 1){
		if (the_instance->channel_connector_) the_instance->channel_connector_->close();
		if (the_instance->game_connector_) the_instance->game_connector_->close();

		write_log("getting channel server.");
		the_instance->net_get_channel(gameid);
	}
}

void GMTools::do_send_cmd()
{
	int	func = ui->cmb_functions->currentData(Qt::UserRole).toInt();
	if (func == 1) {
		write_log("sending command:Dynamic set user stock.");
		std::string param = "showdata ";
		param += "func2 ";
		param += "{F3DD5222-2E8C-48EC-A4E7-BDBA4E96C310} ";
		param += ui->edt_useriid->text().toUtf8();
		the_instance->net_send_cmd(param);
	}
	else if (func == 2) {
		write_log("sending command:Disable user stock.");
		std::string param = "showdata ";
		param += "func2 ";
		if (ui->edt_useriid->text() != "") {
			param += "{93531DC0-9663-47E1-87F4-33EB8B0EE9D7} ";
			param += ui->edt_useriid->text().toUtf8();
		}
		else {
			param += "{93531DC0-9663-47E1-87F4-33EB8B0EE9D7}";
		}
		the_instance->net_send_cmd(param);
	}
	else if (func == 3){
		write_log("sending command:Query System Balance.");
		std::string param = "showdata ";
		param += "func2 ";
		param += "{D9ED4D4D-1565-4224-AD64-1D05801E4BC5}";
		the_instance->net_send_cmd(param);
	}
}

void GMTools::schedule_for_next()
{
	QTimer::singleShot(rand_r(60000, 160000), this, SLOT(auto_set()));
}

void GMTools::on_sendcmd()
{
	int	func = ui->cmb_functions->currentData(Qt::UserRole).toInt();
	if (func == 3){
		auto_set_times_ = maxset_;
		ui->btn_sendcmd->setText("send command!");
		do_send_cmd();
	}
	else {
		//如果当前正在自动设置,则停止自动设置
		if (auto_set_times_ < maxset_ && maxset_ > 1) {
			auto_set_times_ = maxset_;
			ui->btn_sendcmd->setText("send command!");
		}
		//如果当前没有自动设置,则开始自动设置
		else if (auto_set_times_ >= maxset_) {
			maxset_ = ui->edt_autoc->text().toInt();
			do_send_cmd();
			auto_set_times_ = 1;
			ui->btn_sendcmd->setText("sending command...");
			schedule_for_next();
		}
		else {
			do_send_cmd();
		}
	}
}

void GMTools::on_reset()
{
	state_ = 0;
	ui->btn_logingame->setText("login to account");
	if (the_instance->channel_connector_) the_instance->channel_connector_->close();
	if (the_instance->game_connector_) the_instance->game_connector_->close();
	if (the_instance->center_connector_) the_instance->center_connector_->close();
	ui->edt_logs->setPlainText("");
	ui->lab_log->setText("");
	ui->btn_logingame->setEnabled(true);
}

void GMTools::write_log(std::string txt)
{
	QString str = ui->edt_logs->toPlainText();
	if (str.length() > 100000) {
		str = "";
	}
	std::string u8 = utf8(txt);
	str += QString::fromUtf8(u8.c_str()) + "\r\n";
	ui->edt_logs->setPlainText(str);
	ui->lab_log->setText(QString::fromUtf8(u8.c_str()));
}

void GMTools::on_msg(msg_base& msg)
{
	if (msg.from_sock_.lock() == the_instance->channel_connector_) {
		on_chnmsg(msg);
	}
	else if (msg.from_sock_.lock() == the_instance->center_connector_) {
		on_accmsg(msg);
	}
	else {
		on_gamemsg(msg);
	}
}

void GMTools::on_chnmsg(msg_base& msg)
{
	int	gameid = ui->cmb_allgame->currentData(Qt::UserRole).toInt();
	if (msg.head_.cmd_ == (GET_CLSID(msg_switch_game_server))) {
		write_log("get game server succ, will login to game.");
		int ret = the_instance->connect_to_game();
		if (ret != 0) {
			write_log("can not connect to game server.");
			return;
		}
		write_log("game server connected, will send login info.");
		the_instance->net_login_to_game();
	}
	else if (msg.head_.cmd_ == GET_CLSID(msg_common_reply)) {
		msg_common_reply* pmsg = (msg_common_reply*)&msg;
		if (pmsg->rp_cmd_ == GET_CLSID(msg_user_login_channel)) {
			if (pmsg->err_ == 0) {
				write_log("login channel server succ, will get game server.");
				the_instance->net_get_gameserver(gameid);
			}
			else {
				write_log("msg_common_reply, error=" + lx2s(pmsg->err_));
			}
		}
		else
			write_log("msg_common_reply, error=" + lx2s(pmsg->err_));
	}
}

void GMTools::on_gamemsg(msg_base& msg)
{
	if (msg.head_.cmd_ == GET_CLSID(msg_user_login_ret_game)) {
		ui->edt_logs->setPlainText("");
		write_log("login game server succ, please enjoy the show.");
		ui->btn_logingame->setEnabled(false);
	}
	else if (msg.head_.cmd_ == GET_CLSID(msg_query_data_rsp)) {
		msg_query_data_rsp* pmsg = (msg_query_data_rsp*)&msg;
		write_log("cmd reply:" + pmsg->data_);
	}
	else if (msg.head_.cmd_ == GET_CLSID(msg_common_reply)) {
		msg_common_reply* pmsg = (msg_common_reply*)&msg;
		write_log("msg_common_reply, error=" + lx2s(pmsg->err_));
	}
}

void GMTools::on_accmsg(msg_base& msg)
{
	int	gameid = ui->cmb_allgame->currentData(Qt::UserRole).toInt();
	if (msg.head_.cmd_ == (GET_CLSID(msg_user_login_ret))) {
		state_ = 1;
		ui->btn_logingame->setText("login channel");
		write_log("login account server succ");
	}
	else if (msg.head_.cmd_ == GET_CLSID(msg_channel_server)) {
		write_log("get channel server succ, will login to channel server.");
		int ret = the_instance->connect_to_channel();
		if (ret != 0) {
			write_log("can not connect to channel server.");
			return;
		}
		write_log("channel server connected, will send login info.");
		the_instance->net_login_to_channel();
	}
	else if (msg.head_.cmd_ == GET_CLSID(msg_common_reply)) {
		msg_common_reply* pmsg = (msg_common_reply*)&msg;
		write_log("msg_common_reply, error=" + lx2s(pmsg->err_));
	}
	else if (msg.head_.cmd_ == GET_CLSID(msg_game_data)) {
		ui->cmb_allgame->clear();

		for each(auto it in the_instance->all_games)
		{
			ui->cmb_allgame->addItem(QString::fromUtf8(it.second->game_name_), it.second->id_);
		}
	}
}

