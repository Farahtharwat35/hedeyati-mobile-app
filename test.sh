#!/bin/bash

DRIVER_PATH="test_driver/integration_test_driver.dart"
RECORD_TIMEOUT=200
START_RECORD_AFTER=50
export MSYS_NO_PATHCONV=1 #disable path conversion

if [ ! -f "pubspec.yaml" ]; then
    echo "This script must be run from the root of the Flutter project."
    exit 1
fi
# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
          --keep)
                    KEEP=true
                    shift 2
                    ;;
          --device_id)
                    DEVICE_ID="$2"
                    ADB_DEVICE_ID_ARG="-s $DEVICE_ID"
                    FLUTTER_DEVICE_ID_ARG="--device-id $DEVICE_ID"
                    shift 2
                    ;;
          --record_timeout)
                    RECORD_TIMEOUT="$2"
                    shift 2
                    ;;
          --wait_for_emulator)
                    START_RECORD_AFTER="$2"
                    shift 2
                    ;;
        --test_path)
            TEST_PATH="$2"
            TEST_NAME=$(basename $TEST_PATH)
            if [ -z "$OUTPUT_VIDEO" ]; then
              OUTPUT_VIDEO=$(dirname $TEST_PATH)/recording.mp4
            fi
            shift 2
            ;;
        --driver_path)
            DRIVER_PATH="$2"
            shift 2
            ;;
        --output_video)
            OUTPUT_VIDEO="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [--test_path path] [--driver_path PATH] [--output_video PATH]"
            echo "  --test_path         The name of the test to run (required)"
            echo "  --driver_path       The path to the integration test driver (default: test_driver/integration_test_driver.dart)"
            echo "  --output_video      The path to save the recording (default: <dirname test_path>/recording.mp4)"
            echo "  --record_timeout      The maximum time in seconds to wait for the test to complete (default: $RECORD_TIMEOUT)"
            echo "  --wait_for_emulator The time in seconds to wait for before starting recording (default: $START_RECORD_AFTER)"
            exit 0
            ;;
        *)
            echo "Unknown argument: $1"
            echo "Use --help for usage information."
            exit 1
            ;;
    esac
done



if [ -z "$TEST_PATH" ]; then
    echo "Test path is required. Use --help for usage information."
    exit 1
fi
echo "Test path:    $TEST_PATH"
echo "Driver path:  $DRIVER_PATH"
echo "Output video: $OUTPUT_VIDEO"
echo "Test timeout: $RECORD_TIMEOUT"
echo "Wait for emulator: $START_RECORD_AFTER"


if [ -z "$RUN_START_DATE" ]; then
    RUN_START_DATE=$(date +"%Y_%m_%d_%H_%M_%S") #potentail for regression launcher later :)
fi

ON_DEVICE_NAME="${RUN_START_DATE}_$(basename ${TEST_NAME%.*}).mp4" #ensure no collision
ON_DEVICE_OUTPUT_FILE="/sdcard/$ON_DEVICE_NAME"
echo "ON_DEVICE_OUTPUT_FILE: $ON_DEVICE_OUTPUT_FILE"


before_test=$(date +"%T")
echo "$ flutter drive --driver=$DRIVER_PATH --target=$TEST_PATH $FLUTTER_DEVICE_ID_ARG &"
flutter drive  --driver=$DRIVER_PATH --target=$TEST_PATH $FLUTTER_DEVICE_ID_ARG &
TEST_PID=$!
echo "Running Flutter Drive... PID: $TEST_PID"

echo "Starting Record in $START_RECORD_AFTER"
sleep $START_RECORD_AFTER;
echo "Recording..."
echo "$ adb  $ADB_DEVICE_ID_ARG shell \"screenrecord --size 720x1280 --time-limit $RECORD_TIMEOUT $ON_DEVICE_OUTPUT_FILE \"  & "
adb $ADB_DEVICE_ID_ARG shell "screenrecord --size 720x1280 --time-limit $RECORD_TIMEOUT $ON_DEVICE_OUTPUT_FILE" &
RECORDING_PID=$!

wait $TEST_PID
exit_status=$?
if [ $exit_status -ne 0 ]; then
    echo "Test failed"
    STATUS=FAILED
else
    echo "Test passed"
    STATUS=PASSED
fi
after_test=$(date +"%T")

#test time in seconds
test_took=$(( $(date -d $after_test +%s) - $(date -d $before_test +%s) ))
echo "Test took: ${test_took}s"
#recomend if timeout is greater that test by 20s
if [ $(($RECORD_TIMEOUT + $START_RECORD_AFTER - $test_took)) -gt 10 ]; then
    echo "consider adjusting record_timeout from $RECORD_TIMEOUT if the recording is too long,"
fi
#print the remaining each second
test_took2=$test_took
echo "recording in progress";
while [ $test_took2 -lt $((RECORD_TIMEOUT + $START_RECORD_AFTER )) ]; do
    echo "Record will end in $(($RECORD_TIMEOUT  + $START_RECORD_AFTER - $test_took2))s"
    #check if $RECORDING_PID is done
    if ! ps -p $RECORDING_PID > /dev/null
    then
        echo "Recording completed"
        break
    fi
    sleep 5
    test_took2=$((test_took2 + 5))
done
wait $RECORDING_PID

idle_time=$(( $(date +%s) - $(date -d $after_test +%s) ))

echo "Fetching the recorded video from $ON_DEVICE_OUTPUT_FILE $OUTPUT_VIDEO..."
rm -rf $OUTPUT_VIDEO
adb $ADB_DEVICE_ID_ARG pull $ON_DEVICE_OUTPUT_FILE $OUTPUT_VIDEO
if [ "$?" -ne 0 ]; then
    echo "Failed to fetch the video. Please check your device connection."
fi

# Remove the video from the device
adb $ADB_DEVICE_ID_ARG shell rm $ON_DEVICE_OUTPUT_FILE

echo "Test and recording completed successfully."
echo "Video saved to: $OUTPUT_VIDEO"
mkdir -p  "run/run_$RUN_START_DATE"
touch "run/run_$RUN_START_DATE/report.txt"
echo "TC: " >> "run/run_$RUN_START_DATE/report.txt"
echo "    PATH      : $TEST_PATH"     >> "run/run_$RUN_START_DATE/report.txt"
echo "    STATUS    : $STATUS"        >> "run/run_$RUN_START_DATE/report.txt"
echo "    Duration  : $test_took"     >> "run/run_$RUN_START_DATE/report.txt"
echo "    Idle time : $idle_time"     >> "run/run_$RUN_START_DATE/report.txt"
echo "    Output:   : $OUTPUT_VIDEO"  >> "run/run_$RUN_START_DATE/report.txt"
echo "________________________________________________________________________________________" >> "run/run_$RUN_START_DATE/report.txt"
echo "" >> "run/run_$RUN_START_DATE/report.txt"
exit 0