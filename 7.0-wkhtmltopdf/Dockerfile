# Pull base image.
FROM actency/docker-apache-php:7.0-dev

# Install WKHTMLTOPDF from sources
RUN apt-get update && apt-get remove -y libqt4-dev qt4-dev-tools wkhtmltopdf && apt-get autoremove -y
RUN apt-get install openssl build-essential libssl-dev libxrender-dev git-core libx11-dev libxext-dev libfontconfig1-dev libfreetype6-dev fontconfig -y
RUN git clone git://github.com/wkhtmltopdf/wkhtmltopdf.git /var/wkhtmltopdf
RUN mkdir /var/qt-wkhtmltopdf && cd /var/qt-wkhtmltopdf && git clone https://www.github.com/wkhtmltopdf/qt --depth 1 --branch wk_4.8.7 --single-branch .
RUN cd /var/qt-wkhtmltopdf && echo "yes" | ./configure -nomake tools,examples,demos,docs,translations -opensource -prefix "`pwd`" `cat ../wkhtmltopdf/static_qt_conf_base ../wkhtmltopdf/static_qt_conf_linux | sed -re '/^#/ d' | tr '\n' ' '` && make -j3 && make install
RUN cd /var/wkhtmltopdf && ../qt-wkhtmltopdf/bin/qmake && make -j3 && make install
RUN chown -R web:www-data /var/qt-wkhtmltopdf/ && chown -R web:www-data /var/wkhtmltopdf

# Expose 80 for apache, 9000 for xdebug
EXPOSE 80 9000

# Set and run a custom entrypoint
COPY core/docker-entrypoint.sh /
RUN chmod 777 /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
