/********************************************************************************
** Form generated from reading UI file 'login.ui'
**
** Created by: Qt User Interface Compiler version 5.11.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_LOGIN_H
#define UI_LOGIN_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDialog>
#include <QtWidgets/QFormLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_login
{
public:
    QFormLayout *formLayout;
    QLabel *label;
    QLabel *useriid;
    QLineEdit *edt_uname;
    QLabel *useriid_2;
    QLineEdit *edt_psw;
    QPushButton *btnlogin;
    QLabel *label_2;

    void setupUi(QDialog *login)
    {
        if (login->objectName().isEmpty())
            login->setObjectName(QStringLiteral("login"));
        login->resize(290, 330);
        login->setMinimumSize(QSize(290, 330));
        login->setMaximumSize(QSize(290, 330));
        login->setStyleSheet(QString::fromUtf8("font: 25 12pt \"\345\276\256\350\275\257\351\233\205\351\273\221\";"));
        login->setSizeGripEnabled(false);
        formLayout = new QFormLayout(login);
        formLayout->setObjectName(QStringLiteral("formLayout"));
        formLayout->setHorizontalSpacing(12);
        formLayout->setVerticalSpacing(12);
        formLayout->setContentsMargins(30, 20, 30, 20);
        label = new QLabel(login);
        label->setObjectName(QStringLiteral("label"));
        label->setMinimumSize(QSize(0, 60));
        label->setAlignment(Qt::AlignCenter);
        label->setWordWrap(true);

        formLayout->setWidget(0, QFormLayout::SpanningRole, label);

        useriid = new QLabel(login);
        useriid->setObjectName(QStringLiteral("useriid"));

        formLayout->setWidget(1, QFormLayout::SpanningRole, useriid);

        edt_uname = new QLineEdit(login);
        edt_uname->setObjectName(QStringLiteral("edt_uname"));
        QSizePolicy sizePolicy(QSizePolicy::Expanding, QSizePolicy::Preferred);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(edt_uname->sizePolicy().hasHeightForWidth());
        edt_uname->setSizePolicy(sizePolicy);
        edt_uname->setAlignment(Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter);

        formLayout->setWidget(2, QFormLayout::SpanningRole, edt_uname);

        useriid_2 = new QLabel(login);
        useriid_2->setObjectName(QStringLiteral("useriid_2"));

        formLayout->setWidget(3, QFormLayout::SpanningRole, useriid_2);

        edt_psw = new QLineEdit(login);
        edt_psw->setObjectName(QStringLiteral("edt_psw"));
        edt_psw->setEnabled(true);
        sizePolicy.setHeightForWidth(edt_psw->sizePolicy().hasHeightForWidth());
        edt_psw->setSizePolicy(sizePolicy);
        edt_psw->setEchoMode(QLineEdit::Password);
        edt_psw->setAlignment(Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter);

        formLayout->setWidget(4, QFormLayout::SpanningRole, edt_psw);

        btnlogin = new QPushButton(login);
        btnlogin->setObjectName(QStringLiteral("btnlogin"));
        QSizePolicy sizePolicy1(QSizePolicy::Preferred, QSizePolicy::Preferred);
        sizePolicy1.setHorizontalStretch(0);
        sizePolicy1.setVerticalStretch(0);
        sizePolicy1.setHeightForWidth(btnlogin->sizePolicy().hasHeightForWidth());
        btnlogin->setSizePolicy(sizePolicy1);
        btnlogin->setMinimumSize(QSize(150, 0));

        formLayout->setWidget(5, QFormLayout::SpanningRole, btnlogin);

        label_2 = new QLabel(login);
        label_2->setObjectName(QStringLiteral("label_2"));
        label_2->setAlignment(Qt::AlignCenter);

        formLayout->setWidget(6, QFormLayout::SpanningRole, label_2);


        retranslateUi(login);

        QMetaObject::connectSlotsByName(login);
    } // setupUi

    void retranslateUi(QDialog *login)
    {
        login->setWindowTitle(QApplication::translate("login", "Please login", nullptr));
        label->setText(QApplication::translate("login", "Welcome to use GMTools, feel free to use.", nullptr));
        useriid->setText(QApplication::translate("login", "user-iid:", nullptr));
        edt_uname->setText(QApplication::translate("login", "hongjt", nullptr));
        useriid_2->setText(QApplication::translate("login", "password:", nullptr));
        edt_psw->setText(QString());
        btnlogin->setText(QApplication::translate("login", "verify user", nullptr));
        label_2->setText(QApplication::translate("login", "Please login GM system.", nullptr));
    } // retranslateUi

};

namespace Ui {
    class login: public Ui_login {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_LOGIN_H
