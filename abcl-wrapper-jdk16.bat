@echo off
java -cp C:\abcl\abcl.jar;"%CLASSPATH%" -XshowSettings:vm -Dfile.encoding=UTF-8 -XX:CompileThreshold=10 org.armedbear.lisp.Main %1 %2 %3 %4 %5 %6 %7 %8 %9
