#include "version_builder.h"
#include <QFileDialog>
#include <QSettings>
#include <QMessageBox>
#include <QTextCodec>
#include <QtXml>
#include <QCryptographicHash>
#include <set>
#include <utility.h>

#define TVD_ROLE_NODE		(Qt::UserRole)

#define UC(str)\
	QString::fromStdString(ucs2(str))
struct ver_node
{
	QString		path_;
	int				edit_mark_;	//1忽略，0正常
	int				is_inzip_;
	int				is_dir_;
	std::vector<ver_node> childs;
	QTreeWidgetItem* tv_item_;
	void reset()
	{
		path_ = "";
		edit_mark_ = 0;
		is_dir_ = 1;
		is_inzip_ = 0;
		childs.clear();
		tv_item_ = nullptr;
	}
};

ver_node	nroot_dir;
std::map<QAbstractButton*, ver_node*> btn_node_map;
std::set<QString>		ignores;
std::set<QString>		zips;
static  int		projc = 1;
version_builder::version_builder(QWidget *parent)
	: QMainWindow(parent)
{
	ui.setupUi(this);
	QObject::connect(ui.browse_loadp, SIGNAL(released()), this, SLOT(set_loadfrom_dir()));
	QObject::connect(ui.browse_savep, SIGNAL(released()), this, SLOT(set_saveto_dir()));
	QObject::connect(ui.browse_zipp, SIGNAL(released()), this, SLOT(set_zipfile()));
	
	QObject::connect(ui.btn_refresh_pattern, SIGNAL(released()), this, SLOT(refresh_pattern()));
	QObject::connect(ui.btn_reset, SIGNAL(released()), this, SLOT(reset_patterns()));
	QObject::connect(ui.tv_dir, SIGNAL(itemClicked(QTreeWidgetItem*, int)), 
		this, SLOT(dir_item_clicked(QTreeWidgetItem*, int)));

	ui.tv_dir->header()->resizeSection(1, 100);
	ui.tv_dir->header()->resizeSection(2, 100);
	on_new_file();
}

version_builder::~version_builder()
{

}

void version_builder::set_loadfrom_dir()
{
	QFileDialog dlg;
	dlg.setFileMode(QFileDialog::DirectoryOnly);
	int ret = dlg.exec();
	if(ret){
		QString newp = dlg.directory().absolutePath();
		if (newp != ui.edt_src_path->text()){

			int ret = QMessageBox::question(
				this, 
				UC("确认"), 
				UC("重新设置路径会丢失所有改动，确定要执行吗？"));
			if (ret == QMessageBox::No){
				return;
			}

		}
		ui.edt_src_path->setText(newp);

		nroot_dir.reset();
		refresh_dir_node();
		refresh_dir_tree();
	}
}

void version_builder::set_saveto_dir()
{
	QFileDialog dlg;
	dlg.setFileMode(QFileDialog::DirectoryOnly);
	int ret = dlg.exec();
	if(ret){
		ui.edt_save_path->setText(dlg.directory().absolutePath());
	}
}

void version_builder::refresh_pattern()
{
	refresh_dir_node();
	refresh_dir_tree();
}

void version_builder::save_result()
{
	if (ui.edt_size->text() != ""){
		if (ui.edt_size->text() == "" ||
			ui.edt_sign->text() == "")	{
				return;
		}
	}

	QDomDocument doc;

	QDomProcessingInstruction pi = doc.createProcessingInstruction("xml", "version=\"1.0\" encoding=\"UTF-8\"");
	doc.appendChild(pi);

	QDomElement ver = doc.createElement("dir");
	ver.setAttribute("n", QFileInfo(nroot_dir.path_).fileName());
	ver.setAttribute("v", ui.edt_version->text());
	ver.setAttribute("d", QDateTime::currentDateTime().toString("yyyy-MM-dd"));
	doc.appendChild(ver);

	if (ui.edt_zip->text() != ""){
		QDomElement zips = doc.createElement("zips");
		QDomElement zip = doc.createElement("f");

		zip.setAttribute("n", ui.edt_zip->text());
		zip.setAttribute("s", ui.edt_size->text());
		QDomText text = doc.createTextNode(ui.edt_sign->text());
		zip.appendChild(text);
		zips.appendChild(zip);
		ver.appendChild(zips);
	}

	build_xml_document(doc, ver, nroot_dir, nroot_dir.is_inzip_);

	QString xml = doc.toString(4);//4表示缩进长度
	QFile xmlf(ui.edt_save_path->text());
	if(!xmlf.open(QFile::WriteOnly)){
		QMessageBox::warning(nullptr,
			UC("警告"),
			UC("无法写入version_config.xml!"));
		return;
	}
	QTextStream strm(&xmlf);
	doc.save(strm, 4);//4表示缩进长度

	int v = ui.edt_version->text().toInt();	v++;
	ui.edt_version->setText(QString().setNum(v));

	do_save_file(false);

	QMessageBox::information(nullptr, 
		UC("提示"),
		UC("版本已生成！"));
}

void version_builder::build_dir_tree(ver_node& node, QTreeWidgetItem* item)
{
	QFileInfo f(node.path_);
	node.tv_item_ = item;
	item->setText(0, f.fileName());
	item->setData(0, TVD_ROLE_NODE, (uint)&node);

	QPushButton* btn = new QPushButton();
	QString style = "font: 9pt \"" + UC("微软雅黑") + "\";";
	if (node.edit_mark_ == 1){
		item->setIcon(0, QIcon("./Resources/manglu.png"));

		btn->setText(UC("取消"));
		undo_ignore_group_->addButton(btn);
		style += "color: rgb(255, 0, 0);";
	}
	else{
		btn->setText(UC("忽略"));
		ignore_group_->addButton(btn);
		item->setIcon(0, QIcon("./Resources/zaixian.png"));
	}	

	btn_node_map.insert(std::make_pair(btn, &node));
	ui.tv_dir->setItemWidget(item, 1, btn);

	if (node.is_dir_ && node.edit_mark_ == 0){
		style += "color: rgb(0, 0, 255);";
	}

	btn->setStyleSheet(style);

	btn = new QPushButton();
	style = "font: 9pt \"" + UC("微软雅黑") + "\";";
	if (node.is_inzip_ == 1){
		btn->setText(UC("是"));
		in_zip_group_->addButton(btn);
		style += "color: rgb(255, 0, 0);";
	}
	else{
		btn->setText(UC("不是"));
		not_in_zip_group_->addButton(btn);
	}
	ui.tv_dir->setItemWidget(item, 2, btn);

	btn_node_map.insert(std::make_pair(btn, &node));

	if (node.is_dir_ && node.is_inzip_ == 1){
		style += "color: rgb(0, 0, 255);";
	}

	btn->setStyleSheet(style);

	if (node.is_dir_ && node.edit_mark_ == 0){
		for (int i = 0; i < node.childs.size(); i++)
		{
			QTreeWidgetItem* sub_item = new QTreeWidgetItem(item);
			build_dir_tree(node.childs[i], sub_item);
		}
	}
}

void version_builder::dir_item_clicked(QTreeWidgetItem* item, int col)
{

}

void version_builder::refresh_dir_tree()
{
	ui.tv_dir->clear();
	btn_node_map.clear();

	ignore_group_ = new QButtonGroup(this);
	undo_ignore_group_ = new QButtonGroup(this);
	not_in_zip_group_ = new QButtonGroup(this);
	in_zip_group_ = new QButtonGroup(this);

	QObject::connect(ignore_group_, SIGNAL(buttonReleased(QAbstractButton *)), 
		this, SLOT(ignore_item(QAbstractButton*)));

	QObject::connect(undo_ignore_group_, SIGNAL(buttonReleased(QAbstractButton *)), 
		this, SLOT(undo_ignore_item(QAbstractButton*)));

	QObject::connect(in_zip_group_, SIGNAL(buttonReleased(QAbstractButton *)), 
		this, SLOT(not_in_zip(QAbstractButton*)));

	QObject::connect(not_in_zip_group_, SIGNAL(buttonReleased(QAbstractButton *)), 
		this, SLOT(in_zip(QAbstractButton*)));

	QTreeWidgetItem* item = new QTreeWidgetItem(ui.tv_dir);
	build_dir_tree(nroot_dir, item);
	ui.tv_dir->expandAll();
}

void version_builder::build_dir_node(QDir& dir, ver_node& node)
{
	QString pattern = ui.edt_patterns->text();
	QStringList flst = dir.entryList(QDir::Files);
	for (int i = 0; i < flst.size(); i++)
	{
		QFileInfo f(flst[i]);
		QString suffix = "." + f.suffix();
		if (pattern.contains(suffix)){
			ver_node fnode;
			fnode.path_ = dir.absolutePath() + "/" + flst[i];
			fnode.is_dir_ = 0;
			fnode.edit_mark_ = (ignores.find(fnode.path_) != ignores.end());
			fnode.is_inzip_ = (zips.find(fnode.path_) != zips.end());
			node.childs.push_back(fnode);
		}
	}

	QStringList lst = dir.entryList(QDir::Dirs);
	for (int i = 0; i < lst.size(); i++)
	{
		if (lst[i] == "." || lst[i] == "..") continue;
		ver_node fnode;
		fnode.path_ = dir.absolutePath() + "/" + lst[i];
		fnode.is_dir_ = 1;
		fnode.edit_mark_ = (ignores.find(fnode.path_) != ignores.end());
		fnode.is_inzip_ = (zips.find(fnode.path_) != zips.end());
		dir.cd(lst[i]);
		build_dir_node(dir, fnode);
		dir.cdUp();
		node.childs.push_back(fnode);
	}
}

void version_builder::refresh_dir_node()
{
	nroot_dir.reset();

	QFileInfo fi(ui.edt_src_path->text());
	QDir dir(fi.absoluteFilePath());
	nroot_dir.path_ = fi.absoluteFilePath();
	nroot_dir.edit_mark_ = (ignores.find(nroot_dir.path_) != ignores.end());
	nroot_dir.is_inzip_ = (zips.find(nroot_dir.path_) != zips.end());
	build_dir_node(dir, nroot_dir);
}

void version_builder::reset_patterns()
{
	ui.edt_patterns->setText(".exe .dll .xml .plist .ExportJson .png .jpg .bmp .json .mp3 .wav .ttf .fnt .ico .pvr.ccz .csb");
}

void version_builder::ignore_item(QAbstractButton * button)
{
	auto itf = btn_node_map.find(button);
	if (itf != btn_node_map.end()){
		itf->second->edit_mark_ = 1;
		if (itf->second->is_dir_){
			refresh_dir_tree();
		}
		else{
			itf->second->tv_item_->setIcon(0, QIcon("./Resources/manglu.png"));
			button->setText(UC("取消"));
			QString style = "font: 9pt \"" + UC("微软雅黑") + "\";";
			style += "color: rgb(255, 0, 0);";

			button->setStyleSheet(style);
			ignore_group_->removeButton(button);
			undo_ignore_group_->addButton(button);
		}
	}
}

void version_builder::undo_ignore_item(QAbstractButton * button)
{
	auto itf = btn_node_map.find(button);
	if (itf != btn_node_map.end()){
		itf->second->edit_mark_ = 0;
		if (itf->second->is_dir_){
			refresh_dir_tree();
		}
		else{
			itf->second->tv_item_->setIcon(0, QIcon("./Resources/zaixian.png"));
			button->setText(UC("忽略"));

			QString style = "font: 9pt \"" + UC("微软雅黑") + "\";";
			if (itf->second->is_dir_){
				style += "color: rgb(0, 0, 255);";
			}
			else{
				style += "color: rgb(0, 0, 0);";
			}

			button->setStyleSheet(style);

			undo_ignore_group_->removeButton(button);
			ignore_group_->addButton(button);
		}
	}
}

void version_builder::build_xml_document(QDomDocument& doc, QDomNode& dom_node, ver_node& node, int is_inzip)
{
	for (int i = 0 ; i < node.childs.size(); i++)
	{
		ver_node& vn = node.childs[i];
		if (vn.edit_mark_ == 1) continue;

		bool this_in_zip = is_inzip | vn.is_inzip_;

		QDomElement child;
		if (vn.is_dir_){	
			child = doc.createElement("dir");
			build_xml_document(doc, child, vn, this_in_zip);
		}
		//如果是文件
		else{
			child = doc.createElement("f");
			QFile f(vn.path_);
			if(f.open(QFile::ReadOnly)){
				QCryptographicHash md5(QCryptographicHash::Md5);
				if(md5.addData(&f)){
					QDomText text = doc.createTextNode(md5.result().toHex());
					child.appendChild(text);
				}
			}
			else{
				QDomText text = doc.createTextNode("open fail!");
				child.appendChild(text);
			}
			child.setAttribute("s", f.size());
			if (this_in_zip){
				child.setAttribute("zip", ui.edt_zip->text());
			}
		}
		QFileInfo fi(vn.path_);
		child.setAttribute("n", fi.fileName());
		dom_node.appendChild(child);
	}
}

void version_builder::save_ignores(ver_node& node, QSettings& setting, int& indx)
{
	if (node.edit_mark_ == 1){
		setting.setArrayIndex(indx++);
		setting.setValue("name", node.path_);
	}
	else{
		for (int i = 0; i < node.childs.size(); i++)
		{
			save_ignores(node.childs[i], setting, indx);
		}
	}
}

void version_builder::on_about()
{
	QMessageBox::information(nullptr, 
		UC("关于"),
		UC("version builder 1.0版\r\n\r\n制作人: 洪建涛\r\n\r\n更新日: 2015-6-15"));
}

void version_builder::on_open_file()
{
	QFileDialog dlg;
	dlg.setFileMode(QFileDialog::ExistingFile);
	dlg.setNameFilter("ini file (*.ini)");
	if (dlg.exec()){
		QStringList flst = dlg.selectedFiles();
		if (!flst.empty()) {
			ui.edt_project->setText(flst[0]);
			open_project();
		}
	}
}

void version_builder::on_save_file()
{
	do_save_file(true);
}

void version_builder::on_new_file()
{
	ui.edt_project->setText(QDir::currentPath() + "/new_project" + QString().setNum(projc++) +".ini");
	open_project();
}

void version_builder::open_project()
{
	QSettings set(ui.edt_project->text(), QSettings::Format::IniFormat);
	QVariant va1 = set.value("loadfrom");
	if (va1.isValid()){
		ui.edt_src_path->setText(va1.toString());
	}

	QVariant va2 = set.value("patterns");
	if (va2.isValid()){
		ui.edt_patterns->setText(va2.toString());
	}
	else
		reset_patterns();

	QVariant va3 = set.value("saveto");
	if (va3.isValid()){
		ui.edt_save_path->setText(va3.toString());
	}

	QVariant va4 = set.value("version");
	if (va4.isValid()){
		ui.edt_version->setText(va4.toString());
	}
	else{
		ui.edt_version->setText(QString().setNum(1000));
	}

	QVariant va5 = set.value("zipfile");
	if (va5.isValid()){
		ui.edt_zip->setText(va5.toString());
	}
	else{
		ui.edt_zip->setText("update.zip");
	}

	QVariant va6 = set.value("zipsize");
	if (va6.isValid()){
		ui.edt_size->setText(va6.toString());
	}
	else{
		ui.edt_size->setText("");
	}

	QVariant va7 = set.value("zipsign");
	if (va7.isValid()){
		ui.edt_sign->setText(va7.toString());
	}
	else{
		ui.edt_sign->setText("");
	}

	ignores.clear();//只在读取的时候设置初始的忽略对像
	
	int count = set.beginReadArray("ignores");
	for (int i = 0 ; i < count; i++)
	{
		set.setArrayIndex(i);
		ignores.insert(set.value("name").toString());
	}
	set.endArray();

	count = set.beginReadArray("zips");
	for (int i = 0 ; i < count; i++)
	{
		set.setArrayIndex(i);
		zips.insert(set.value("name").toString());
	}
	set.endArray();

	refresh_dir_node();
	
	ignores.clear();
	zips.clear();

	refresh_dir_tree();
}

void version_builder::do_save_file(bool showtip /*= true*/)
{
	QSettings setting(ui.edt_project->text(), QSettings::Format::IniFormat);

	setting.setValue("saveto", ui.edt_save_path->text());
	setting.setValue("version", ui.edt_version->text());
	setting.setValue("loadfrom", ui.edt_src_path->text());
	setting.setValue("patterns", ui.edt_patterns->text());
	setting.setValue("zipfile", ui.edt_zip->text());
	setting.setValue("zipsize", ui.edt_size->text());
	setting.setValue("zipsign", ui.edt_sign->text());
	int index = 0;
	
	setting.beginWriteArray("ignores");
	save_ignores(nroot_dir, setting, index);
	setting.endArray();

	index = 0;
	setting.beginWriteArray("zips");
	save_zip(nroot_dir, setting, index);
	setting.endArray();

	setting.sync();

	if (showtip){
		QMessageBox::information(nullptr, 
			UC("提示"),
			UC("工程文件保存成功！"));
	}
}

void version_builder::in_zip(QAbstractButton * button)
{
	auto itf = btn_node_map.find(button);
	if (itf != btn_node_map.end()){
		itf->second->is_inzip_ = 1;
		if (itf->second->is_dir_){
			refresh_dir_tree();
		}
		else{
			button->setText(UC("是"));
			QString style = "font: 9pt \"" + UC("微软雅黑") + "\";";
			style += "color: rgb(255, 0, 0);";

			button->setStyleSheet(style);
			not_in_zip_group_->removeButton(button);
			in_zip_group_->addButton(button);
		}
	}
}

void clean_zip(ver_node* nd)
{
	nd->is_inzip_ = 0;
	for (int i = 0; i < nd->childs.size(); i++)
	{
		clean_zip(&nd->childs[i]);
	}
}


void version_builder::not_in_zip(QAbstractButton * button)
{
	auto itf = btn_node_map.find(button);
	if (itf != btn_node_map.end()){
		itf->second->is_inzip_ = 0;
		if (itf->second->is_dir_){
			refresh_dir_tree();
		}
		else{

			button->setText(UC("不是"));
			QString style = "font: 9pt \"" + UC("微软雅黑") + "\";";
			if (itf->second->is_dir_){
				style += "color: rgb(0, 0, 255);";
			}
			else{
				style += "color: rgb(0, 0, 0);";
			}
			button->setStyleSheet(style);
			in_zip_group_->removeButton(button);
			not_in_zip_group_->addButton(button);
		}
	}
}

void version_builder::save_zip(ver_node& node, QSettings& setting, int& indx)
{
	if (node.is_inzip_ == 1){
		setting.setArrayIndex(indx++);
		setting.setValue("name", node.path_);
	}
	else{
		for (int i = 0; i < node.childs.size(); i++)
		{
			save_zip(node.childs[i], setting, indx);
		}
	}
}

void version_builder::set_zipfile()
{
	QFileDialog dlg;
	dlg.setFileMode(QFileDialog::ExistingFile);
	dlg.setNameFilter("zip file (*.zip)");
	if (dlg.exec()){
		QStringList flst = dlg.selectedFiles();
		if (!flst.empty()) {
			QFileInfo fi(flst[0]);
			ui.edt_zip->setText(fi.fileName());

			QFile f1(flst[0]);
			if(f1.open(QFile::ReadOnly)){
				QCryptographicHash md5(QCryptographicHash::Md5);
				if(md5.addData(&f1)){
					ui.edt_sign->setText(md5.result().toHex());
				}
			}
			QFile f(flst[0]);
			ui.edt_size->setText(QString().setNum(f.size()));
		}
	}
}

