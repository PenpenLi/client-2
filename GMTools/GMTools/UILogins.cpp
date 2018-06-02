#include "UILogins.h"
#include "ui_login.h"
#include "http_request.h"
#include "utility.h"
#include "http_request.hpp"
#include "file_system.h"
#include "md5.h"
#include "QTimer"
#include "GMTools.h"
#include "shared_data.h"

int get_http_data(std::string url, std::string& ret, boost::asio::io_service& ios, bool wait_data, std::string header)
{
	boost::shared_ptr<http_data_request> req(new http_data_request(ios));
	std::string host, port, params;
	split_url(url, host, port, params);
	std::string str_req = build_http_request(host, params, header);
	req->request(str_req, host, port);

	if (wait_data) {
		//同步等待数据
		int old_size = 0;
		time_t t = ::time(nullptr);
		bool	is_timeout = false;
		while (!req->is_stopped())
		{
			if ((::time(nullptr) - t) >= 5) {
				is_timeout = true;
				break;
			}
			ios.reset();
			ios.poll();
		}

		if (req->is_complete()) {
			ret = req->data();
			return 0;
		}
		else if (!req->redirect_url_.empty()) {
			ret.clear();
			return get_http_data(req->redirect_url_, ret, ios, wait_data, header);
		}
		else {
		}
		return -1;
	}
	else {
		return 0;
	}
}


UILogins::UILogins()
{
	ui = new Ui::login();
	ui->setupUi(this);
	connect(ui->btnlogin, SIGNAL(clicked()), this, SLOT(on_btn_login()));
}

UILogins::~UILogins()
{
	delete ui;
}

std::string			md5_hash(std::string sign_pat)
{
	CMD5 md5;
	unsigned char	out_put[16];
	md5.MessageDigest((unsigned char*)sign_pat.c_str(), sign_pat.length(), out_put);

	std::string sign_key;
	for (int i = 0; i < 16; i++)
	{
		char aa[4] = { 0 };
		sprintf_s(aa, 4, "%02x", out_put[i]);
		sign_key += aa;
	}
	return sign_key;
}
void UILogins::on_btn_login()
{
	ui->label_2->setText("");
	ui->btnlogin->setEnabled(false);

	std::string uname = ui->edt_uname->text().toUtf8();
	std::string psw = ui->edt_psw->text().toUtf8();
	
	std::string url = "http://www.ffsel.com/checkuser.aspx?uname="+ uname +"&psw=" + md5_hash(psw);
	boost::asio::io_service ios;
	std::string check_ret;
	int ret = get_http_data(url, check_ret, ios, true, "");

	if (check_ret == "keyisok")
	{
		ui->label_2->setText("login succ.");
		QTimer::singleShot(1000, this, SLOT(switch_to_main()));
	}
	else {
		ui->label_2->setText(check_ret.c_str());
		ui->btnlogin->setEnabled(true);
	}
}

void UILogins::switch_to_main()
{
	close();
	GMTools w;
	main_controller::get_instance()->mainw_ = &w;
	w.exec();
}
