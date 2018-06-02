#include "UILogins.h"
#include <QtWidgets/QApplication>
#include "file_system.cpp"
#include "net_socket_native.cpp"
#include "http_request.cpp"
#include "md5.cpp"
#include "msg.cpp"
#include "base64Con.cpp"
#include "json_helper.cpp"
#include "shared_data.h"

main_controller* the_instance = nullptr;
int main(int argc, char *argv[])
{
	the_instance = main_controller::get_instance();
	QApplication a(argc, argv);
	UILogins w;
	w.show();
	int b = a.exec();
	main_controller::free_instance();
	return b;
}
