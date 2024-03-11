

class EbookData
{
    final String language;
    final String url;
    final String author;
    final String filetype;
    final String publisher;
    final String uploader;
    final String size;

    const EbookData({this.language = "", required this.url, required this.author, required this.filetype,
      this.publisher = "", this.uploader = "", this.size = ""});
}