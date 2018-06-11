/********************************************************************************
** Form generated from reading UI file 'GMTools.ui'
**
** Created by: Qt User Interface Compiler version 5.11.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_GMTOOLS_H
#define UI_GMTOOLS_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QDialog>
#include <QtWidgets/QFormLayout>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QPlainTextEdit>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_GMToolsClass
{
public:
    QFormLayout *formLayout;
    QLabel *label_6;
    QLineEdit *edt_addr;
    QLabel *label_3;
    QLineEdit *edt_accname;
    QLabel *label_2;
    QLineEdit *edt_psw;
    QComboBox *cmb_allgame;
    QWidget *widget;
    QHBoxLayout *horizontalLayout;
    QPushButton *btn_logingame;
    QPushButton *btn_reset;
    QLabel *lab_log;
    QLabel *label;
    QLineEdit *edt_useriid;
    QLabel *label_4;
    QComboBox *cmb_functions;
    QWidget *widget_2;
    QHBoxLayout *horizontalLayout_2;
    QPushButton *btn_sendcmd;
    QLabel *label_5;
    QLineEdit *edt_autoc;
    QPlainTextEdit *edt_logs;

    void setupUi(QDialog *GMToolsClass)
    {
        if (GMToolsClass->objectName().isEmpty())
            GMToolsClass->setObjectName(QStringLiteral("GMToolsClass"));
        GMToolsClass->resize(456, 709);
        GMToolsClass->setMinimumSize(QSize(0, 0));
        GMToolsClass->setMaximumSize(QSize(16777215, 16777215));
        GMToolsClass->setStyleSheet(QString::fromUtf8("font: 25 12pt \"\345\276\256\350\275\257\351\233\205\351\273\221\";"));
        formLayout = new QFormLayout(GMToolsClass);
        formLayout->setSpacing(6);
        formLayout->setContentsMargins(11, 11, 11, 11);
        formLayout->setObjectName(QStringLiteral("formLayout"));
        formLayout->setFieldGrowthPolicy(QFormLayout::AllNonFixedFieldsGrow);
        formLayout->setHorizontalSpacing(12);
        formLayout->setVerticalSpacing(12);
        formLayout->setContentsMargins(30, 30, 30, 30);
        label_6 = new QLabel(GMToolsClass);
        label_6->setObjectName(QStringLiteral("label_6"));

        formLayout->setWidget(0, QFormLayout::LabelRole, label_6);

        edt_addr = new QLineEdit(GMToolsClass);
        edt_addr->setObjectName(QStringLiteral("edt_addr"));

        formLayout->setWidget(0, QFormLayout::FieldRole, edt_addr);

        label_3 = new QLabel(GMToolsClass);
        label_3->setObjectName(QStringLiteral("label_3"));

        formLayout->setWidget(1, QFormLayout::LabelRole, label_3);

        edt_accname = new QLineEdit(GMToolsClass);
        edt_accname->setObjectName(QStringLiteral("edt_accname"));

        formLayout->setWidget(1, QFormLayout::FieldRole, edt_accname);

        label_2 = new QLabel(GMToolsClass);
        label_2->setObjectName(QStringLiteral("label_2"));

        formLayout->setWidget(2, QFormLayout::LabelRole, label_2);

        edt_psw = new QLineEdit(GMToolsClass);
        edt_psw->setObjectName(QStringLiteral("edt_psw"));
        edt_psw->setEchoMode(QLineEdit::Password);

        formLayout->setWidget(2, QFormLayout::FieldRole, edt_psw);

        cmb_allgame = new QComboBox(GMToolsClass);
        cmb_allgame->addItem(QString());
        cmb_allgame->setObjectName(QStringLiteral("cmb_allgame"));
        cmb_allgame->setEditable(false);

        formLayout->setWidget(3, QFormLayout::FieldRole, cmb_allgame);

        widget = new QWidget(GMToolsClass);
        widget->setObjectName(QStringLiteral("widget"));
        horizontalLayout = new QHBoxLayout(widget);
        horizontalLayout->setSpacing(6);
        horizontalLayout->setContentsMargins(11, 11, 11, 11);
        horizontalLayout->setObjectName(QStringLiteral("horizontalLayout"));
        horizontalLayout->setContentsMargins(0, 0, 0, 0);
        btn_logingame = new QPushButton(widget);
        btn_logingame->setObjectName(QStringLiteral("btn_logingame"));
        btn_logingame->setMinimumSize(QSize(180, 0));

        horizontalLayout->addWidget(btn_logingame);

        btn_reset = new QPushButton(widget);
        btn_reset->setObjectName(QStringLiteral("btn_reset"));

        horizontalLayout->addWidget(btn_reset);


        formLayout->setWidget(4, QFormLayout::FieldRole, widget);

        lab_log = new QLabel(GMToolsClass);
        lab_log->setObjectName(QStringLiteral("lab_log"));
        QSizePolicy sizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(lab_log->sizePolicy().hasHeightForWidth());
        lab_log->setSizePolicy(sizePolicy);
        lab_log->setAlignment(Qt::AlignLeading|Qt::AlignLeft|Qt::AlignVCenter);
        lab_log->setWordWrap(true);

        formLayout->setWidget(5, QFormLayout::FieldRole, lab_log);

        label = new QLabel(GMToolsClass);
        label->setObjectName(QStringLiteral("label"));

        formLayout->setWidget(6, QFormLayout::LabelRole, label);

        edt_useriid = new QLineEdit(GMToolsClass);
        edt_useriid->setObjectName(QStringLiteral("edt_useriid"));

        formLayout->setWidget(6, QFormLayout::FieldRole, edt_useriid);

        label_4 = new QLabel(GMToolsClass);
        label_4->setObjectName(QStringLiteral("label_4"));

        formLayout->setWidget(7, QFormLayout::LabelRole, label_4);

        cmb_functions = new QComboBox(GMToolsClass);
        cmb_functions->addItem(QString());
        cmb_functions->addItem(QString());
        cmb_functions->addItem(QString());
        cmb_functions->setObjectName(QStringLiteral("cmb_functions"));

        formLayout->setWidget(7, QFormLayout::FieldRole, cmb_functions);

        widget_2 = new QWidget(GMToolsClass);
        widget_2->setObjectName(QStringLiteral("widget_2"));
        horizontalLayout_2 = new QHBoxLayout(widget_2);
        horizontalLayout_2->setSpacing(6);
        horizontalLayout_2->setContentsMargins(11, 11, 11, 11);
        horizontalLayout_2->setObjectName(QStringLiteral("horizontalLayout_2"));
        horizontalLayout_2->setContentsMargins(0, 0, 0, 0);
        btn_sendcmd = new QPushButton(widget_2);
        btn_sendcmd->setObjectName(QStringLiteral("btn_sendcmd"));

        horizontalLayout_2->addWidget(btn_sendcmd);

        label_5 = new QLabel(widget_2);
        label_5->setObjectName(QStringLiteral("label_5"));
        QSizePolicy sizePolicy1(QSizePolicy::Fixed, QSizePolicy::Preferred);
        sizePolicy1.setHorizontalStretch(0);
        sizePolicy1.setVerticalStretch(0);
        sizePolicy1.setHeightForWidth(label_5->sizePolicy().hasHeightForWidth());
        label_5->setSizePolicy(sizePolicy1);
        label_5->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        horizontalLayout_2->addWidget(label_5);

        edt_autoc = new QLineEdit(widget_2);
        edt_autoc->setObjectName(QStringLiteral("edt_autoc"));
        QSizePolicy sizePolicy2(QSizePolicy::Preferred, QSizePolicy::Fixed);
        sizePolicy2.setHorizontalStretch(0);
        sizePolicy2.setVerticalStretch(0);
        sizePolicy2.setHeightForWidth(edt_autoc->sizePolicy().hasHeightForWidth());
        edt_autoc->setSizePolicy(sizePolicy2);
        edt_autoc->setMaximumSize(QSize(40, 16777215));
        edt_autoc->setAlignment(Qt::AlignCenter);

        horizontalLayout_2->addWidget(edt_autoc);


        formLayout->setWidget(8, QFormLayout::FieldRole, widget_2);

        edt_logs = new QPlainTextEdit(GMToolsClass);
        edt_logs->setObjectName(QStringLiteral("edt_logs"));
        sizePolicy.setHeightForWidth(edt_logs->sizePolicy().hasHeightForWidth());
        edt_logs->setSizePolicy(sizePolicy);
        edt_logs->setMinimumSize(QSize(0, 300));
        edt_logs->setMaximumSize(QSize(16777215, 16777215));
        edt_logs->setReadOnly(true);

        formLayout->setWidget(9, QFormLayout::SpanningRole, edt_logs);


        retranslateUi(GMToolsClass);

        QMetaObject::connectSlotsByName(GMToolsClass);
    } // setupUi

    void retranslateUi(QDialog *GMToolsClass)
    {
        GMToolsClass->setWindowTitle(QApplication::translate("GMToolsClass", "GMTools", nullptr));
        label_6->setText(QApplication::translate("GMToolsClass", "svr address:", nullptr));
        edt_addr->setText(QApplication::translate("GMToolsClass", "clogin.koko.com:10001", nullptr));
        label_3->setText(QApplication::translate("GMToolsClass", "user account:", nullptr));
        edt_accname->setText(QApplication::translate("GMToolsClass", "18657174377", nullptr));
        label_2->setText(QApplication::translate("GMToolsClass", "password:", nullptr));
        edt_psw->setText(QApplication::translate("GMToolsClass", "123456", nullptr));
        cmb_allgame->setItemText(0, QApplication::translate("GMToolsClass", "All games", nullptr));

        btn_logingame->setText(QApplication::translate("GMToolsClass", "login to account", nullptr));
        btn_reset->setText(QApplication::translate("GMToolsClass", "reset", nullptr));
        lab_log->setText(QApplication::translate("GMToolsClass", "please login to game.", nullptr));
        label->setText(QApplication::translate("GMToolsClass", "user-iid:", nullptr));
        label_4->setText(QApplication::translate("GMToolsClass", "functions:", nullptr));
        cmb_functions->setItemText(0, QApplication::translate("GMToolsClass", "Dynamic set user stock", nullptr));
        cmb_functions->setItemText(1, QApplication::translate("GMToolsClass", "Disable user stock", nullptr));
        cmb_functions->setItemText(2, QApplication::translate("GMToolsClass", "Query sysbalance", nullptr));

        btn_sendcmd->setText(QApplication::translate("GMToolsClass", "send command!", nullptr));
        label_5->setText(QApplication::translate("GMToolsClass", "Repeat", nullptr));
        edt_autoc->setText(QApplication::translate("GMToolsClass", "10", nullptr));
    } // retranslateUi

};

namespace Ui {
    class GMToolsClass: public Ui_GMToolsClass {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_GMTOOLS_H
