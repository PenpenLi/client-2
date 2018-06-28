#pragma once
#include "iversion_compare.h"
#include "boost/property_tree/ptree.hpp"
#include "boost/property_tree/xml_parser.hpp"
#include "boost/shared_ptr.hpp"
#include "boost/atomic.hpp"

enum
{
	compare_result_add = 1,
	compare_result_update,
	compare_result_del,
	compare_result_noupdate,
	compare_result_download_complete,
	compare_result_in_zip,
};

enum 
{
	node_type_dir,
	node_type_file,
	node_type_zip,
	node_type_file_in_zip,
	node_type_zip_define,
};
using namespace vsp;
struct ver_node;
typedef boost::shared_ptr<ver_node> vern_ptr;
struct ver_node
{
	std::string		name_;
	std::string		sign_;
	std::string		in_zip_file_;//所在压缩文件名

	int				compare_result_;
	int				node_type_; 
	int				size_;

	vern_ptr parent_;
	std::vector<vern_ptr> child_lst;
	ver_node();

	void			reset();
	vern_ptr		find_child_nodeep(ver_node& val);
	std::string		to_path();
};

extern void terminate_multi_opened_process(std::string fname);
class http_download_file;
class version_manager;
typedef boost::shared_ptr<version_manager> dtask_ptr;
typedef boost::shared_ptr<http_download_file> dftask_ptr;

class version_manager : public iversion_compare
{
public:
	std::string				local_path_;
	std::string				remote_path_;
	std::string				exe_;
	
	version_manager();
	~version_manager();
	std::string	version_info(std::string local_path) override;

	void		query_status(vsync_status& st) override;

	int			check_update(std::string exe, std::string local_path, std::string remote_path) override;

	int			install_update() override;
	//停止
	void		clean() override;

	bool		is_working() override;

	int			copy_dir(std::string from_dir, std::string dest_dir, std::string& err) override;
protected:
	boost::shared_ptr<boost::thread>			download_thread_, check_thread_;
	dftask_ptr				current_dl_file;
	std::map<std::string, std::pair<vern_ptr, int>>	zip_files_;
	boost::mutex mtu_;
	boost::asio::io_service ios_;
	boost::atomic<int> 
		state_, progress_, progress_max_, need_restart_, check_result_;
	
	boost::atomic<int>	file_max_, file_succ_, file_failed_;

	vern_ptr	locv, remv;
	//生成远程版本结点
	std::string remote_version_data;

	int			build_version_tree_from_xml(
		std::string local_path,
		boost::property_tree::ptree::value_type& xnode,
		vern_ptr vnode,
		bool is_remote,
		bool isroot);

	//本地版本文件跟远程版本比较，得出变动结果
	//find_type 0 找出所有变动， 1 只找出更改，忽略新增和删除
	bool		compare_local_to_remote(vern_ptr local_node, vern_ptr result_node);

	int			download_all_files(std::string local_root, std::string remote_root, ver_node& vnode);
	virtual int	get_http_data(std::string url, std::string& ret, boost::asio::io_service& ios, bool wait_data = true, std::string header = "") override;
	int			recieving_file(dftask_ptr req);
	int			unzip(std::string path, ver_node& vnode);

	//dir在UpdateDownload里
	int			move_download_files(std::string local_root, ver_node& vnode);

	int			remove_file_by_version(std::string local_root, ver_node& vnode);
	bool		is_canceled();
	int			do_sync_version();
	int			do_check_update(std::string exe, std::string local_path, std::string remote_path);
};

typedef boost::shared_ptr<version_manager> dtask_ptr;

