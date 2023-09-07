Q: How to sync time between to hosts?
A: $ sudo date --set="$(ssh yongtao@<the-other-host> 'date -u')"
