#pragma once
#include <QTimer>
#include <QDialog>

namespace Ui {
	class GMToolsClass;
};

class msg_base;

class GMTools : public QDialog
{
	Q_OBJECT

public:
	GMTools(QWidget *parent = Q_NULLPTR);
	~GMTools();

public Q_SLOTS:
	void	step();
	void	on_logingame();
	void	on_sendcmd();
	void	on_reset();
	void	write_log(std::string txt);
	void	auto_set();

	void	on_msg(msg_base& msg);
	void	on_accmsg(msg_base& msg);
	void	on_chnmsg(msg_base& msg);
	void	on_gamemsg(msg_base& msg);
private:
	Ui::GMToolsClass* ui;
	int		state_;
	int		auto_set_times_; //0Õ£÷π£¨ 1 ‘ˆº”£¨2ºı…Ÿ
	int		maxset_;

	void	do_send_cmd();
	void	schedule_for_next();
};
