RMDIR /Q/S "target\jre"
jlink --no-header-files --no-man-pages --compress=2 --strip-debug --add-modules "java.base,java.datatransfer,java.desktop,java.logging,java.sql,java.xml,jdk.xml.dom" --output target/jre
