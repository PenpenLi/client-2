#include "http_download_file.h"
#include "file_system.h"
#include "utility.h"
#include "net_socket_basic.cpp"

#ifdef ANDROID
#include <android/log.h>
#define  LOG_TAG    "main"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
#else
#define  LOGD(s, ...)
#endif


http_download_file::http_download_file(std::string tmp_path, boost::asio::io_service& ios) :
	http_request(ios)
{
	tmp_path_ = tmp_path;
	fp = fopen((tmp_path_ + ".tmp").c_str(), "wb");
	old_recv_ = 0;
	uncompress_add_size_ = 0;
	stop_ = false;
	retry_ = 0;
	total_recv_ = 0;
}


http_download_file::~http_download_file()
{
	if (fp){
		fclose(fp);
	}
}

void http_download_file::recv_body(std::string data) 
{
	if (stop_) return;
	data_cache_ += data;
	complete();
}

int http_download_file::on_data_recv(size_t sz)
{
	http_request::on_data_recv(sz);
	total_recv_ += sz;
	return 0;
}

void http_download_file::flush()
{
	unsigned int wl = 0;

	if (fp){
		while (wl < data_cache_.size())
		{
			wl += fwrite(data_cache_.c_str() + wl, 1, data_cache_.size() - wl, fp);
		}
		data_cache_.clear();
	}
}

void http_download_file::complete()
{
	if (stop_) return;

	flush();

	if (fp){
		fclose(fp);
		fp = nullptr;
	}

	std::string data;
	std::string tmpname = tmp_path_ + ".tmp";

	boost::system::error_code ec;
	fs::rename(tmpname, tmp_path_, ec);
	if (ec.value() != 0) {
		std::string err = "file download complete, but can not be saved:" + tmp_path_ + "\r\n";
		LOGD("file saved failed->%s", tmp_path_.c_str());
		save_file("update_log.txt", err, "a+");
	}
	else {
		LOGD("file saved->%s", tmp_path_.c_str());
	}
}

long long http_download_file::uncompress_add()
{
	long long ret = uncompress_add_size_;
	uncompress_add_size_ = 0;
	return ret;
}

void http_download_file::cancel()
{
	close(true);
	stop_ = true;
}
