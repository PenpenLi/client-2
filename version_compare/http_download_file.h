#pragma once
#include "http_request.h"
//////////////////////////////////////////////////////////////////////////
class http_download_file : public http_request
{
public:
	std::string		tmp_path_;
	std::string		hash_;

	long long		old_recv_, total_recv_;
	int				retry_;
	http_download_file(std::string tmp_path, boost::asio::io_service& ios);
	~http_download_file();
	void	complete();
	long long uncompress_add();

	void	cancel();
protected:
	FILE* fp;
	long long	 uncompress_add_size_;
	std::string data_cache_;
	bool	stop_;
	
	void	recv_body(std::string data);
	void	flush();
};