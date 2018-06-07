#include "version_builder.h"
#include <QtWidgets/QApplication>

int main(int argc, char *argv[])
{
	QApplication a(argc, argv);
	version_builder w;
	w.showMaximized();
	return a.exec();
}
