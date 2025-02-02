package io.ballerina.runtime.internal;

import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.types.semtype.Context;
import io.ballerina.runtime.api.types.semtype.SemType;
import io.ballerina.runtime.internal.types.semtype.MutableSemType;

import java.io.IOException;
import java.util.Optional;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Formatter;
import java.util.logging.LogRecord;
import java.util.logging.Logger;

public class TypeCheckLogger {

    private static final TypeCheckLogger instance = new TypeCheckLogger();
    private final boolean enabled;
    private final Logger logger;

    private TypeCheckLogger() {
        String diagnosticEnable = System.getenv("BAL_LOG_TYPE_CHECK");
        if ("true".equalsIgnoreCase(diagnosticEnable)) {
            enabled = true;
            LogConfig config = getConfig();
            logger = Logger.getLogger(TypeCheckLogger.class.getName());
            Formatter formater = new LogFormater();
            config.filePath.ifPresent(filePath -> {
                try {
                    FileHandler fileHandler = new FileHandler(filePath);
                    fileHandler.setFormatter(formater);
                    logger.addHandler(fileHandler);
                } catch (IOException e) {
                    throw new RuntimeException("Failed to initialize typecheck logger", e);
                }
            });
            if (!config.isSilent) {
                ConsoleHandler consoleHandler = new ConsoleHandler();
                consoleHandler.setFormatter(formater);
                logger.addHandler(consoleHandler);
            }
        } else {
            enabled = false;
            logger = null;
        }
    }

    public static TypeCheckLogger getInstance() {
        return instance;
    }

    public void typeCreatedDynamically(Type type) {
        if (enabled) {
            logger.info("Type created dynamically: " + type);
        }
    }

    public void typeResolutionStarted(MutableSemType type) {
        if (enabled) {
            logger.info("Type resolution started: " + type);
        }
    }

    public void typeResolutionDone(MutableSemType type) {
        if (enabled) {
            logger.info("Type resolution done: " + type);
        }
    }

    public void shapeCheckStarted(Context cx, Object value, Type type) {
        if (enabled) {
            logger.info("Shape check started: " + cx + ", value: " + value + ", type: " + type);
        }
    }

    public void shapeCheckDone(Context cx, Object value, Type type, boolean result) {
        if (enabled) {
            logger.info("Shape check done: " + cx + ", value: " + value + ", type: " + type + ", result: " + result);
        }
    }

    public void typeCheckStarted(Context cx, Type t1, Type t2) {
        if (enabled) {
            logger.info("Type check started: " + cx + ", t1: " + t1 + ", t2: " + t2);
        }
    }

    public void typeCheckCachedResult(Context cx, Type t1, Type t2, Optional<Boolean> result) {
        if (enabled) {
            logger.info("Type check cached result: " + cx + ", t1: " + t1 + ", t2: " + t2 + ", result: " + result);
        }
    }

    public void semTypeCheckStarted(Context cx, SemType t1, SemType t2) {
        if (enabled) {
            logger.info("SemType check started: " + cx + ", t1: " + t1 + ", t2: " + t2);
        }
    }

    public void semTypeCheckDone(Context cx, SemType t1, SemType t2, boolean result) {
        if (enabled) {
            logger.info("SemType check done: " + cx + ", t1: " + t1 + ", t2: " + t2 + ", result: " + result);
        }
    }

    public void typeCheckDone(Context cx, Type t1, Type t2, boolean result) {
        if (enabled) {
            logger.info("Type check done: " + cx + ", t1: " + t1 + ", t2: " + t2 + ", result: " + result);
        }
    }

    private static LogConfig getConfig() {
        String logPath = System.getenv("BAL_LOG_TYPE_CHECK_PATH");
        boolean isSilent = System.getenv("BAL_LOG_TYPE_CHECK_SILENT") != null;
        if (logPath == null) {
            if (isSilent) {
                throw new IllegalArgumentException(
                        "Type check logging is enabled but set to silent and no log path provided");
            }
            return new LogConfig(Optional.empty(), false);
        }
        return new LogConfig(Optional.of(logPath), isSilent);
    }

    record LogConfig(Optional<String> filePath, boolean isSilent) {

    }

    private static class LogFormater extends Formatter {

        @Override
        public String format(LogRecord record) {
            return String.format("%1$tc %2$s%n", record.getMillis(), record.getMessage());
        }
    }
}
