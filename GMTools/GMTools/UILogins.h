#pragma once
#include <QDialog>

namespace Ui { class login; }
class UILogins : public QDialog
{
	Q_OBJECT

public:
	UILogins();
	~UILogins();

public Q_SLOTS:
void	on_btn_login();
void	switch_to_main();
protected:
	Ui::login* ui;
};

