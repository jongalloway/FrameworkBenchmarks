FROM maven:3.5.3-jdk-8 as maven
WORKDIR /revenj-jvm
COPY src src
COPY pom.xml pom.xml
COPY web.xml web.xml

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list
RUN apt-get update
RUN apt-get install -y mono-complete mono-fastcgi-server

RUN wget -q https://github.com/ngs-doo/revenj/releases/download/1.4.2/dsl-compiler.zip
RUN unzip -o dsl-compiler.zip
RUN rm dsl-compiler.zip
RUN mvn compile war:war -q

FROM techempower/resin-java8:0.1
COPY --from=maven /revenj-jvm/target/revenj.war ${RESIN_HOME}/webapps/ROOT.war
CMD java -jar ${RESIN_HOME}/lib/resin.jar console
