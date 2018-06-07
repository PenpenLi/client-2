#ifndef VERSION_BUILDER_H
#define VERSION_BUILDER_H

#include <QtWidgets/QMainWindow>
#include "ui_version_builder.h"

class		QDir;
struct  ver_node;
class		QDomNode;
class		QDomDocument;
class		QSettings;

class version_builder : public QMainWindow
{
	Q_OBJECT

public:
	version_builder(QWidget *parent = 0);
	~version_builder();

public Q_SLOTS:
	void		set_loadfrom_dir();
	void		set_saveto_dir();
	void		set_zipfile();
	void		refresh_pattern();
	void		save_result();
	void		reset_patterns();
	void		dir_item_clicked(QTreeWidgetItem* item, int col);
	void		ignore_item(QAbstractButton * button);
	void		undo_ignore_item(QAbstractButton * button);

	void		in_zip(QAbstractButton * button);
	void		not_in_zip(QAbstractButton * button);

	void		on_new_file();
	void		on_save_file();
	void		on_open_file();
	void		on_about();

private:

	Ui::version_builder ui;	
	QButtonGroup* ignore_group_, *undo_ignore_group_, *in_zip_group_, *not_in_zip_group_;

	void		refresh_dir_tree();
	void		build_dir_tree(ver_node& node, QTreeWidgetItem* item);

	void		refresh_dir_node();
	void		build_dir_node(QDir& dir, ver_node& node);

	void		build_xml_document(QDomDocument& doc, QDomNode& dom_node, ver_node& node, int is_inzip);

	void		save_ignores(ver_node& node, QSettings& setting, int& indx);
	void		save_zip(ver_node& node, QSettings& setting, int& indx);

	void		open_project();
	void		do_save_file(bool showtip = true);
};

#endif // VERSION_BUILDER_H
