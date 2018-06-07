#include "utility.h"
#include "file_system.h"
#include "http_download_file.h"
#include "http_request.cpp"

#ifdef WIN32
#include "native_win32.cpp"
#endif

#include "file_system.cpp"
#include "boost/property_tree/xml_parser.hpp"
#include "boost/thread.hpp"
#include "boost/chrono.hpp"
#include <math.h>
//
#include "version_compare.h"
#include "md5.h"
#include "md5.cpp"
#include "net_socket_native.cpp"

#include "ZipUtils.h"

using namespace utlzip;
 
boost::atomic<int>		last_error(0);
  
#ifdef ANDROID
#include <android/log.h>
#define  LOG_TAG    "main"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
#else
#define  LOGD(s, ...)
#endif

 //////////////////////////////////////////////////////////////////////////
 std::string			md5_hash(std::string sign_pat)
 {
 	CMD5 md5;
 	unsigned char	out_put[16];
 	md5.MessageDigest((unsigned char*)sign_pat.c_str(), sign_pat.length(), out_put);
 
 	std::string sign_key;
 	for (int i = 0; i < 16; i++)
 	{
 		char aa[4] = {0};
 		sprintf(aa, "%02x", out_put[i]);
 		sign_key += aa;
 	}
 	return sign_key;
 }
 
 std::string		get_file_md5_hash(fs::path pa)
 {
 	std::string ret;
 	get_file_data(pa, ret);
 	return md5_hash(ret);
 }
 
 static void	 build_version_tree_from_local(vdir dir, vern_ptr vnode)
 {
 	vnode->node_type_ = 1;
 	vnode->name_ = dir.name();
 
 	std::vector<std::string> lst = dir.file_lst_;
 	for (int i = 0; i < lst.size(); i++)
 	{
 		vern_ptr fnode(new ver_node());
 		fnode->parent_ = vnode;
 		if (strstr(lst[i].c_str(), ".zip")){
 			fnode->node_type_ = node_type_zip;
 		}
 		else
 			fnode->node_type_ = node_type_file;
 		fnode->name_ = fs::path(lst[i]).filename().string();
 		fnode->sign_ = get_file_md5_hash( fs::path(lst[i]));
 		vnode->child_lst.push_back(fnode);
 	}
 	lst = dir.dir_lst_;
 	for (int i = 0; i < lst.size(); i++)
 	{
 		if (lst[i] == "." || lst[i] == "..") continue;
 
 		vern_ptr fnode(new ver_node());
 		fnode->parent_ = vnode;
 		fnode->node_type_ = node_type_dir;
 		fnode->name_ = lst[i];
 
 		dir.cd(lst[i]);
 		build_version_tree_from_local(dir, fnode);
 		dir.cdup();
 		vnode->child_lst.push_back(fnode);
 	}
 }
 
 //本地已下载文件跟远程版本比较，目的是排除已下载过的文件
 static void		compare_download_to_remote(ver_node& local_node, ver_node& result_node)
 {
 	//找出需要更新的
 	//需要更新的文件是:文件路径相同，但签名不对，或是文件夹名相同，检查内部文件
 	for (int i = 0; i < local_node.child_lst.size(); i++)
 	{
 		ver_node& pn_local = *local_node.child_lst[i];
 		vern_ptr  pn_remote = result_node.find_child_nodeep(pn_local);
 		if (pn_remote){
 			//如果是文件夹
 			if (pn_local.node_type_ == node_type_dir){
 				//继续比较文件夹内容
 				compare_download_to_remote(pn_local, *pn_remote);
 			}
 			else{
 				//如果两个文件的md5签名一样，说明已经下载完成，不用再下载
 				if (pn_local.sign_ == pn_remote->sign_){
 					pn_remote->compare_result_ = compare_result_download_complete;
 				}
 			}
 		}
 	}
 }
 
 static long long		count_download_size(vern_ptr d, boost::atomic<int>& file_max)
 {
 	long long ret = 0;
 	if ((d->node_type_ == node_type_file || d->node_type_ == node_type_zip) && !
 		(d->compare_result_ == compare_result_noupdate || d->compare_result_ == compare_result_in_zip || 
 		d->compare_result_ == compare_result_download_complete ||
 		d->compare_result_ == compare_result_del)){
 			ret += d->size_;
			file_max++;
			
 	}
 	for (int i = 0; i < d->child_lst.size(); i++)
 	{
 		ret += count_download_size(d->child_lst[i], file_max);
 	}
 	return ret;
 }
 
 int version_manager::recieving_file(dftask_ptr req)
 {
	int l = (req->total_recv_- req->old_recv_);
 	progress_ += l;
 	req->old_recv_ = req->total_recv_;

 	if (req->is_complete()){
 		return error_noerror;
 	}
	else if (!req->context_.redirect_url_.empty()){
		return error_redirect;
	}
 	else if (req->is_stopped()){
		return error_netio_failed;
 	}
	return error_noerror;
 }
 
 int version_manager::get_http_data(std::string url, std::string& ret, boost::asio::io_service& ios, bool wait_data, std::string header)
 {
	std::cout<<"begin get http data:"<<url<<std::endl;
 	boost::shared_ptr<http_request> req(new http_request(ios));
 	std::string host, port, params;
 	split_url(url, host, port, params);
 	std::string str_req = build_http_request(host, params, header);
 	req->request(str_req, host, port);
 	
	if (wait_data){
 		//同步等待数据
 		int old_size = 0;
 		time_t t = ::time(nullptr);
		bool	is_timeout = false;
 		while (!req->is_stopped())
 		{
			if ((::time(nullptr) - t) >= 2)	{
				is_timeout = true;
				break;
			}
 			ios.reset();
 			ios.poll();
 		}

 		if (req->is_complete()){
			std::cout<<"get_http_data finished."<<std::endl;
			ret = req->context_.response_body_;
 			return error_noerror;
 		}
		else if (!req->context_.redirect_url_.empty()){
			std::cout<<"get_http_data need redirect to->"<<req->context_.redirect_url_<<std::endl;
			ret.clear();
			return get_http_data(req->context_.redirect_url_, ret, ios, wait_data, header);
		}
		else{
			if (is_timeout){
				std::cout<<"get_http_data timeout."<<std::endl;
			}
		} 
 		return error_netio_failed;
 	}
 	else{
 		return error_noerror;
 	}
 }
 
 version_manager::version_manager()
 {
 	need_restart_ = false;
 	progress_ = 0;
 	progress_max_ = 100;
 	state_ = st_prepare;
 	locv.reset(new ver_node());
 	remv.reset(new ver_node());
 }
 
 void print_property_tree(boost::property_tree::ptree& dom_node, int deep = 0)
 {
 	auto it = dom_node.begin();
 	while (it != dom_node.end())
 	{
 		boost::property_tree::ptree::value_type& nodev = *it;
 		for (int i = 0 ; i < deep; i++)
 		{
 			std::cout << " ";
 		}
 
 		if(nodev.first == "<xmlattr>"){
 			auto itv = nodev.second.begin();
 			while (itv != nodev.second.end())
 			{
 				std::cout<<std::endl<<itv->first<<"="<<itv->second.data()<<std::endl;
 				itv++;
 			}
 		}
 		else if (nodev.first == "<xmlcomment>"){
 
 		}
 		else {
 			std::cout<<"<"<<nodev.first<<">";
 			if (nodev.first == "dir" || nodev.first == "zips"){
 				std::cout<<std::endl;
 				print_property_tree(it->second, deep + 1);
 			}
 			else if (nodev.first == "f"){
 				std::cout<<nodev.second.data();
 			}
 			std::cout<<"</"<<nodev.first<<">"<<std::endl;
 		}
 		it++;
 	}
 }
 
 std::string get_xml_attr(boost::property_tree::ptree& node, std::string attr)
 {
 	auto v = node.get_child_optional("<xmlattr>." + attr);
 	if (!v){
 		return "";
 	}
 	return v->data();
 }
 
 int version_manager::build_version_tree_from_xml(
 	std::string local_path,
 	boost::property_tree::ptree::value_type& xnode,
 	vern_ptr vnode,
 	bool is_remote,
 	bool isroot)
 {
 	vnode->name_ = get_xml_attr(xnode.second, "n");
 	if (xnode.first == "dir"){
 		vnode->node_type_ = node_type_dir;
 
 		auto xcval = xnode.second.begin();
 		while (xcval != xnode.second.end())
 		{
 			if (xcval->first == "<xmlattr>" || 
 				xcval->first == "<xmlcomment>"){
 					xcval++;
 					continue;
 			}
 
 			vern_ptr  vchild_node(new ver_node());
 			vchild_node->parent_ = vnode;
 			int ret = 0;
 			if (isroot || local_path == ""){
 				ret = build_version_tree_from_xml(local_path, *xcval, vchild_node, is_remote, false);
 			}
 			else
 				ret = build_version_tree_from_xml(local_path + vnode->name_ + "/", *xcval, vchild_node, is_remote, false);
 
 			if (ret == 0){
 				vnode->child_lst.push_back(vchild_node);	
 			}
 			xcval++;
 		}
 	}
 	//zip file 只是增加一个记录
 	else if (xnode.first == "zips"){
 		if (is_remote){
 			auto xval = xnode.second.begin();
 			while (xval != xnode.second.end())
 			{
 				vern_ptr vn(new ver_node());
 				vn->node_type_ = node_type_zip;
 				vn->name_ = get_xml_attr(xval->second, "n");
 				vn->size_ = s2i<int>(get_xml_attr(xval->second, "s"));
 				vn->sign_ = xval->second.data();
 				zip_files_.insert(std::make_pair(vn->name_, std::make_pair(vn, 0)));
 				xval++;
 			}
 			return 1;
 		}
 		else{
 			vnode->node_type_ = node_type_zip_define;
 			vnode->name_ = "zipdir";
 		}
 	}
 	//文件
 	else if(xnode.first == "f") {
 		//跳过版本描述文件本身.
 		if (vnode->name_ == "version_config.xml"){
 			return 1;
 		}
 		//如果是本地配置文件，需要检查文件是否存在，只有存在的文件，才写入结点列表，不存在的文件是无效的结点。
 		if (!is_remote){
 			fs::path pa(local_path);
 			pa += fs::path(vnode->name_);
 			if (file_exist(pa.string()) || local_path == ""){
 				vnode->node_type_ = node_type_file;
 				vnode->sign_ = get_file_md5_hash(pa); //本地文件直接求hash值
 			}
 			else{
 				//如果文件不存在,则不记录这个结点.
 				return 1; 
 			}
 		}
 		else{
 			vnode->node_type_ = node_type_file;
 			vnode->sign_ = xnode.second.data();
 		}
 
 		vnode->in_zip_file_ = get_xml_attr(xnode.second, "zip");
 		vnode->size_ = s2i<int>(get_xml_attr(xnode.second, "s"));
 		if (vnode->in_zip_file_ != ""){
 			vnode->node_type_ = node_type_file_in_zip;
 		}
 	}
 	return 0;
 }
 
 //编辑版本文件的时候，如果某个文件夹结点设置为压缩文件，则文件夹下的所有文件都在压缩文件里。
 //文件夹的是否压缩文件的属性只体现在文件上，文件夹本身不体现。
 bool version_manager::compare_local_to_remote(vern_ptr local_node, vern_ptr result_node)
 {
 	bool will_update = false;
 	//找出需要更新的
 	//需要更新的文件是:文件路径相同，但签名不对，或是文件夹名相同，检查内部文件
 	for (int i = 0; i < local_node->child_lst.size(); i++)
 	{
 		vern_ptr pn_local = local_node->child_lst[i];
 		if (pn_local->node_type_ == node_type_zip_define) continue;
 
 		vern_ptr pn_remote = result_node->find_child_nodeep(*pn_local);
 		if (pn_remote){
 			//如果是文件夹
 			if (pn_local->node_type_ == node_type_dir){
 				//继续比较文件夹内容
 				will_update |= compare_local_to_remote(pn_local, pn_remote);
 			}
 			else{
 				//如果两个文件的md5签名不一样，说明需要更新，加入更新列表
 				if (pn_local->sign_ != pn_remote->sign_){
 					//如果目标文件在zip里，则下载zip包
 					if (pn_remote->node_type_ == node_type_file_in_zip){
 						auto itf = zip_files_.find(pn_remote->in_zip_file_);
 						if (itf != zip_files_.end()){
 							itf->second.second = 1;
 						}
 						//不下载本文件
 						pn_remote->compare_result_ = compare_result_in_zip;
 						will_update = true;
 					}
 					else{
 						pn_remote->compare_result_ = compare_result_update;
 						will_update = true;
 					}
 				}
 				else{
 					pn_remote->compare_result_ = compare_result_noupdate;
 				}
 			}
 		}
 		else{
 
 			vern_ptr pn_del(new ver_node());
 			pn_del->name_ = pn_local->name_;
 			pn_del->compare_result_ = compare_result_del;
 			pn_del->node_type_ = pn_local->node_type_;
 			pn_del->parent_ = result_node;
 			result_node->child_lst.push_back(pn_del);
			will_update = true;
 		}
 	}
 	//找出需要添加的
 	//需要添加的文件是: 新版本里有，旧版本里不存在的文件和文件夹
 	for (int i = 0; i < result_node->child_lst.size(); i++)
 	{
 		vern_ptr pn_remote = result_node->child_lst[i];
 		if (pn_remote->node_type_ == node_type_zip_define) continue;
 		vern_ptr pn_local = local_node->find_child_nodeep(*pn_remote);
 		if (!pn_local)	{
 			if (pn_remote->node_type_ == node_type_dir){
 				will_update |= compare_local_to_remote(vern_ptr(new ver_node()), pn_remote);
 			}
 			else{
 				if (pn_remote->node_type_ == node_type_file_in_zip){
 					auto itf = zip_files_.find(pn_remote->in_zip_file_);
 					if (itf != zip_files_.end()){
 						itf->second.second = 1;
 					}
 					//不下载本文件
 					pn_remote->compare_result_ = compare_result_in_zip;
 					will_update = true;
 				}
 				else{
 					pn_remote->compare_result_ = compare_result_add;
 					will_update = true;
 				}
 			}
 		}
 	}
 	return will_update;
 }
 
 dftask_ptr download_file(std::string remote_root,
	 std::string local_root,
	 ver_node child, 
	 boost::asio::io_service& ios_,
	 std::string extra_head)
 {
	 std::string rmpath = remote_root + child.to_path();
	 std::string locpath = local_root + child.to_path();

	 dftask_ptr req(new http_download_file(locpath, ios_));
	 std::cout<<"file:->"<<rmpath<<std::endl;
	 req->request(rmpath, extra_head);
	 return req;
 }


 int version_manager::download_all_files(std::string local_root, std::string remote_root, ver_node& vnode)
 {
 	int ret = error_noerror;

	std::vector<ver_node> vdirs;
	std::vector<ver_node> vfiles;

 	for (int i = 0; i < vnode.child_lst.size(); i++)
 	{
 		ver_node& child = *vnode.child_lst[i];
 		if (child.compare_result_ == compare_result_noupdate ||
 			child.compare_result_ == compare_result_download_complete ||
 			child.compare_result_ == compare_result_in_zip ||
 			child.compare_result_ == compare_result_del) continue;
 
 		if (is_canceled())
 			return error_io_canceled;
		
 		if (child.node_type_ == node_type_dir){
			vdirs.push_back(child);
 		}
 		else{
			vfiles.push_back(child);
 		}
 	}

	std::vector<dftask_ptr> vdf;
	for (unsigned i = 0; i < vfiles.size(); i++)
	{
		dftask_ptr task = download_file(remote_root, local_root, vfiles[i], ios_, "");
		task->hash_ = vfiles[i].sign_;
		vdf.push_back(task);
	}

	bool all_finished = false;
	int old_finish_count = 0;
	while (!all_finished && !is_canceled())
	{
		ios_.reset();
		ios_.poll();
		all_finished = true;
		int finished_count = 0;
		int tsize = vdf.size(); 
		for (int i = vdf.size() - 1; i >= 0; i--)
		{		
			if (is_canceled()) break;

			dftask_ptr task = vdf[i];

			int rc = recieving_file(vdf[i]);
			if (rc == error_should_retry_download || rc == error_redirect){
				if (rc == error_should_retry_download){
					std::cout << "file retry:->rmpath" << task->url() <<std::endl;
					vdf[i]->cancel();
					dftask_ptr ntask = download_file(remote_root, local_root, vfiles[i], ios_, "cache-control:no-cache\r\n");
					ntask->hash_ = vdf[i]->hash_;
					vdf[i] = ntask;
				}
				else if (rc == error_redirect)	{
					std::cout << "file redirect:->rmpath" << task->context_.redirect_url_ <<std::endl;
					vdf[i]->cancel();
					std::string str_redicrect = task->context_.redirect_url_;
					task.reset(new http_download_file(local_root + vfiles[i].to_path(), ios_));
					task->request(str_redicrect);
					task->hash_ = vdf[i]->hash_;
					vdf[i] = task;
				}
			}
			else if(rc != error_noerror || vdf[i]->recv_timeout() > 10){
				std::string err = "file download failed:" + task->url() + "\r\n";
				err += "request_state=" + lx2s(task->context_.request_state_) +
					" totalrecv=" + lx2s(task->total_recv_) + " timeout =" + lx2s(task->recv_timeout()) +"\r\n";
				err += "header=" + task->context_.response_header_ + "\r\n";

				save_file("update_log.txt", err, "a+");
				std::cout<<err<<task->url()<<std::endl;

				if (vdf[i]->recv_timeout() > 10){
					vdf[i]->cancel();
				}
				last_error = error_fileio_failed;
			}

			//文件下载完成,验证版本,不匹配的,重新下.
			if (vdf[i]->is_complete()){
				std::string shash = get_file_md5_hash(fs::path(vdf[0]->tmp_path_));
				if (shash == vdf[i]->hash_){
					progress_ += vdf[i]->uncompress_add();
					finished_count++;
					file_succ_++;
					vdf.erase(vdf.begin() + i);
				}
				else if(vdf[i]->retry_ >= 3){
					std::cout << "hash not match, version:"<< vdf[i]->hash_ 
						<< " download:"<<shash<< " file:"<< task->url() <<std::endl;
					vdf[i]->cancel();
					dftask_ptr ntask = download_file(remote_root, local_root, vfiles[i], ios_, "cache-control:no-cache\r\n");
					ntask->retry_ = vdf[i]->retry_ + 1;
					ntask->hash_ = vdf[i]->hash_;
					vdf[i] = ntask;
				}
				else{
					vdf.erase(vdf.begin() + i);
					file_failed_++;
				}
			}
			else if(rc != error_noerror ||
				(!vdf[i]->is_complete() && vdf[i]->recv_timeout() > 10)){
				vdf.erase(vdf.begin() + i);
				file_failed_++;
			}
			else{
				all_finished = false;
			}
		}
		if (old_finish_count != finished_count){
			old_finish_count = finished_count;
			std::cout<<"finished:"<<finished_count<<"total:"<<tsize<<std::endl;
		}
		boost::this_thread::sleep_for(boost::chrono::milliseconds(1));
	}


	for (unsigned i = 0; i < vdirs.size(); i++)
	{ 
		//创建目录
		fs::path pa(local_root);
		pa += fs::path(vdirs[i].to_path());
		boost::system::error_code ec;
		fs::create_directories(pa, ec);
		if (ec.value() == 0){
			ret = download_all_files(local_root, remote_root, vdirs[i]);
		}
		else{
			std::string err = "directory create failed when downloading file:" + pa.string() + "\r\n";
			save_file("update_log.txt", err, "a+");
		}
	}

	return error_noerror;
 }
 
 int version_manager::unzip(std::string path, ver_node& vnode)
 {
 	int p = 0;
 	for (int i = 0; i < vnode.child_lst.size(); i++)
 	{
 		if (vnode.child_lst[i]->node_type_ == node_type_zip){
 			{
 				ZipFile zip(path + vnode.child_lst[i]->name_);
 				std::vector<std::string> fls;
 				zip.fileInfoList(fls);
 				for (int j = 0; j < fls.size(); j++)
 				{
 					std::string& f = fls[j];
 					if (ZipFile::isDir(f)){
 						fs::path pa(path);
 						pa += fs::path(f);
 						boost::system::error_code ec;
 						fs::create_directories(pa, ec);
 						if (ec.value() != 0){
 							
 						}
 					}
 					else{
 						utlzip::ssize_t len = 0;
 						boost::shared_array<unsigned char> data(zip.getFileData(f, &len));
 						if (data.get()){
 							int ret = save_file(path + f, (char*)data.get(), len, "wb+");
 							if(ret != error_noerror){
 								last_error = error_fileio_failed;
 								return last_error;
 							}
 						}
 					}
 				}
 			}
 			fs::path pa(path + vnode.child_lst[i]->name_);
 			boost::system::error_code ec;
 			fs::remove(pa, ec);
 		}
 	}
 	return error_noerror;
 }
 
 int version_manager::move_download_files(std::string local_root, ver_node& vnode)
 {
 	int ret = error_noerror;
 	for (int i = 0; i < vnode.child_lst.size(); i++)
 	{
 		ver_node& child = *vnode.child_lst[i];
 		if (child.compare_result_ == compare_result_noupdate) continue;
 		if (child.compare_result_ == compare_result_del) continue;
 		if (child.node_type_ == node_type_dir){
 
 			fs::path pa(local_root);
 			pa += fs::path(child.to_path());
 			boost::system::error_code ec;
 			fs::create_directories(pa, ec);
 			if (ec.value() == 0){
 				ret = move_download_files(local_root, child);
 			}
 			else{
 				std::string err = "directory create failed when moving file:" + pa.string() + "\r\n";
 				save_file("update_log.txt", err, "a+");
 			}
 		}
 		else if(child.node_type_ != node_type_zip){
 			std::string dir_download = local_root + "UpdateDownload/" + child.to_path();
 			std::string dir_dest = local_root + child.to_path();
 
 			fs::path pa_save_to(dir_dest);
 			fs::path pa_dl(dir_download);
 
 			if(file_exist(dir_dest)){
 				//移除已存在的文件
 				boost::system::error_code ec;
 				fs::remove(pa_save_to, ec);
 				if (ec.value() == EROFS || ec.value() == EIO){
 					fs::path panew(dir_dest + ".hjtremove");
 					fs::rename(pa_save_to, panew, ec);
 					if (ec.value() != 0){
 						//重命名失败，报更新出错
 						ret = error_fileio_failed;
 					}
 					else{
 						need_restart_ = true;
 					}
 				}
 			}
 
 			//如果下载目录中不存在文件
 			if (file_exist(dir_download)){
 				boost::system::error_code ec;
 				fs::rename(pa_dl, pa_save_to, ec);
 
 				if(ec.value() != 0){
 					ret = error_move_file_failed;
 				}
 			}
 		}
 	}
 	return ret;
 }
 
 int version_manager::remove_file_by_version(std::string local_root, ver_node& vnode)
 {
 	for (int i = 0; i < vnode.child_lst.size(); i++)
 	{
 		ver_node& child = *vnode.child_lst[i];
 		fs::path pa(local_root + child.to_path());
 		if (child.compare_result_ != compare_result_del) continue;
 		if (child.node_type_ == node_type_dir){
 			if (fs::exists(pa)){
 				remove_dir(pa.string());
 			}
 		}
 		else if(child.node_type_ != node_type_zip){
 			if(fs::exists(pa)){
 				//移除已存在的文件
 				boost::system::error_code ec;
 				fs::remove(pa, ec);
 				if (ec.value() == EROFS || ec.value() == EIO){
 					fs::path newp(pa.string() + ".hjtremove");
 					fs::rename(pa, newp, ec);
 				}
 			}
 		}
 	}
 	return 0;
 }
 
int version_manager::do_sync_version()
{
	int ret = error_noerror;
	file_failed_ = 0;
	file_succ_ = 0;
	progress_ = 0;
	std::string exe, localp, remotep;
	{
		boost::lock_guard<boost::mutex> lk(mtu_);
		exe = exe_;
		localp = local_path_;
		remotep = remote_path_;

		state_ = st_downloading;
		std::string filep = local_path_ + "version_config.xml";
		if (progress_max_ > 0){
			//下载需要更新和添加的文件
			download_all_files(local_path_ + "UpdateDownload/", remote_path_, *remv);
		}

		//所有文件下载完成，开始搬运
		//考虑自更新，所有在占用的文件都重命名，后辍添加.old，然后再移动新文件，这样不就存在占用
		//软件启动时清理掉重命名的文件(.old文件)。
		if (state_ == st_cancel){
			return error_io_canceled;
		}

		state_ = st_unzip;

		int ret = unzip(local_path_ + "UpdateDownload/", *remv);
		if (ret != error_noerror)	{
			return ret;
		}

#ifdef WIN32
		terminate_multi_opened_process(exe_);
#endif
		state_ = st_moving_file;

		ret = remove_file_by_version(local_path_, *remv);
		ret = move_download_files(local_path_, *remv);

		state_ = st_saving_version_config;
		if (last_error == error_noerror){
			if (ret == error_noerror){
				ret = save_file(filep, remote_version_data, "wb+");
				//删除UpdateDownload目录
				remove_dir(local_path_ + "UpdateDownload");
			}
		}
	}

	state_ = st_finished;
	return error_noerror;
}
 
 std::string version_manager::version_info(std::string local_path)
 {
 	std::string filep = local_path + "version_config.xml";
 	boost::property_tree::ptree xml;
 	try{
 		boost::property_tree::xml_parser::read_xml(filep, xml);
 		boost::property_tree::ptree droot = xml.get_child("dir");
 		std::string d = get_xml_attr(droot, "d");
 		std::string v = get_xml_attr(droot, "v");
 		return "v" + v + "(" + d +")";
 	}
 	catch(boost::property_tree::xml_parser_error& ec){
 		std::string msg = ec.message();
 		return "";
 	}
 }
   
 iversion_compare*  iversion_compare::create_instance()
 {
 	return new version_manager();
 }
 
 void version_manager::clean()
 {
 	//只要取消了当前下载，下载任务任务就会停止
 	if (state_ == st_downloading){
 		state_ = st_cancel;
 	}
 
 	if (download_thread_.get()){
 		download_thread_->join();
 		download_thread_.reset();
 	}
 
 	if (current_dl_file.get()){
 		current_dl_file->close(false);
 	}
 	current_dl_file.reset();
 	
 	ios_.stop();
 }
 
 bool version_manager::is_canceled()
 {
 	return state_ == st_cancel;
 }
 
 int version_manager::check_update(std::string exe, std::string local_path, std::string remote_path)
 {
	boost::lock_guard<boost::mutex> lk(mtu_);

	if(local_path.empty() || remote_path.empty()) 
		return error_version_uptodate;

	if (local_path[local_path.size() - 1] != '/'){
		local_path.push_back('/');
	}
	
	if (remote_path[remote_path.size() - 1] != '/'){
		remote_path.push_back('/');
	}

	local_path_ = local_path;
	remote_path_ = remote_path;

 	exe_ = exe;
	
  	fs::path dir(local_path);

	LOGD("check update for fullpath:%s", fs::absolute(dir).string().c_str());

	if (dir.is_relative()){
		std::vector<std::string> dirs;
		split_str(local_path, "/", dirs, true);
		std::string tmp_dir;
		for (unsigned i = 0; i < dirs.size(); i++)
		{
			tmp_dir += dirs[i] + "/";
			boost::system::error_code ec;
			if(fs::create_directory(tmp_dir, ec)){
				LOGD("dirctory is created:%s", tmp_dir.c_str());
			}
		}
	}
	else{
		boost::system::error_code ec;
		if(fs::create_directory(dir, ec)){
			LOGD("dirctory is created:%s", fs::absolute(dir).string().c_str());
		}
	}

 	locv->reset();
 	remv->reset();
 	remote_version_data.clear();
 
 	std::string filep = local_path + "version_config.xml";
 	//本地版本文件
 	boost::property_tree::ptree local_xml;
 	try{
 		boost::property_tree::xml_parser::read_xml(filep, local_xml);
 	}
 	catch(boost::property_tree::xml_parser_error& ec){
 		std::string msg = ec.message();
 	}
	
 	if (!local_xml.empty()){
 		build_version_tree_from_xml(local_path, local_xml.front(), locv, false, true);
 	}

	boost::asio::io_service tmp_ios;
 	//远程版本文件
 	int ret = get_http_data(remote_path + "version_config.xml", remote_version_data, tmp_ios, true, "cache-control:no-cache\r\n");
	if (ret != error_noerror){
		return error_netio_failed;
	}

 	boost::property_tree::ptree remote_xml;
 	try{

 		std::string str = remote_version_data.data();
 		std::stringstream sstm(str);
 		boost::property_tree::xml_parser::read_xml(sstm, remote_xml);
 	}
 	catch(boost::property_tree::xml_parser_error& ec){
 		std::string msg = ec.message();
 	}

 	build_version_tree_from_xml("", remote_xml.front(), remv, true, true);
 
 	//如果本地版本文件里没有东西,则使用远程文件列表来生成本地的版本文件.
 	if (locv->child_lst.empty()){
 		build_version_tree_from_xml(local_path, remote_xml.front(), locv, false, true);
 	}
 
 	//比较上面两个版本，结果放在remv里。
 	bool will_update = compare_local_to_remote(locv, remv);
 	if (will_update){
		progress_max_ = 100;
		progress_ = 0;
		std::string filep = local_path_ + "version_config.xml";
		vern_ptr	dlv(new ver_node());
		//检查是否存在UpdateDownload文件夹，如果没有，创建它。
		if(!fs::exists(local_path_ + "UpdateDownload")){
			if (!fs::create_directories(local_path_ + "UpdateDownload")){
				last_error = error_io_canceled;
				return last_error;
			}
			else{
				LOGD("directory UpdateDownload created.");
			}
		}
		
		//加入要下载的zip文件
		auto it = zip_files_.begin();
		while (it != zip_files_.end())
		{
			if (it->second.second == 1){
				it->second.first->compare_result_ = compare_result_add;
				it->second.first->parent_ = remv;
				remv->child_lst.push_back(it->second.first);
			}
			it++;
		}
		zip_files_.clear();

		//构造下载目录版本
		vdir dldir(local_path_ + "UpdateDownload/");
		build_version_tree_from_local(dldir, dlv);
		//比较下载目录和远程版本，结果放在remv里
		compare_download_to_remote(*dlv, *remv);
		//最终remv里记录了所有信息，哪些文件需要更新，哪些需要删除，哪些需要添加
		//统计需要下载的文件数量
		progress_max_ = count_download_size(remv, file_max_);
 		return error_version_willupdate;
 	}
 	else{
		clean_rename(local_path_);
 		return error_version_uptodate;
 	}
 }
 
 int version_manager::install_update()
 {
	boost::lock_guard<boost::mutex> lk(mtu_);
 	if (remote_path_ == "" || local_path_ == "" || exe_ == ""){
 		return -1;
 	}
 	//如果正在下载,则不再重新下.
 	if (is_working()){
 		return -2;
 	}
 	download_thread_.reset(new boost::thread(boost::bind(&version_manager::do_sync_version, this)));
 	return 0;
 }
 
 bool version_manager::is_working()
 {
 	if (state_ == vsp::st_finished){
 		return false;
 	}
 	else{
 		if(!download_thread_.get()){
 			return false;
 		}
 		return !download_thread_->try_join_for(boost::chrono::milliseconds(1));
 	}
 }
 
 int version_manager::copy_dir(std::string from_dir, std::string dest_dir, std::string& err)
 {
	 return ::copy_dir(from_dir, dest_dir, err);
 }

 version_manager::~version_manager()
 {
 	clean();
 }
 
 void version_manager::query_status(vsync_status& st)
 {
 	st.st_ = (vsync_st)state_.load();
 	st.progress_ = progress_;
 	st.progress_max_ = progress_max_;
 	st.need_restart_ = need_restart_;
 	st.last_error_ = last_error;
	st.file_failed_ = file_failed_;
	st.file_succ_ = file_succ_;
 }

 ver_node::ver_node()
 {
 	reset();
 }
 
 void ver_node::reset()
 {
 	name_ = "";
 	node_type_ = node_type_file;
 	child_lst.clear();
 	compare_result_ = 0;
 	size_ = 0;
 }
 
 vern_ptr ver_node::find_child_nodeep(ver_node& val)
 {
 	for (int i = 0; i < child_lst.size(); i++)
 	{
 		if(child_lst[i]->name_ == val.name_ && (
 			(child_lst[i]->node_type_ == val.node_type_) || 
 			(child_lst[i]->node_type_ == node_type_file_in_zip &&  val.node_type_ == node_type_file) || 
 			(child_lst[i]->node_type_ == node_type_file &&  val.node_type_ == node_type_file_in_zip))
 			){
 				return child_lst[i];
 		}
 	}
 	return vern_ptr();
 }
 
 std::string ver_node::to_path()
 {
 	std::string path = parent_? name_: "";
 	vern_ptr par = parent_;
 	while (par)
 	{
 		std::string p = par->name_;
 		par = par->parent_;
 		if (par){
 			path = p + "/" + path;
 		}
 	}
 	if (node_type_ == node_type_dir){
 		return path + "/";
 	}
 	else
 		return path;
 }
