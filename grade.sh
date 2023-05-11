set -e

CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests


student_file='./student-submission/ListExamples.java'

if [[ -f $student_file ]]
then
    echo 'Correct file submitted'
else 
    echo 'Incorrect file submitted'
    exit
fi

cp TestListExamples.java $student_file grading-area/

grading_files='./grading-area/*.java'
set +e

javac -cp $CPATH $grading_files
if [[ $? -ne 0 ]]
then 
    echo 'Compiling error occured. Please check your code.'
    exit
else
    echo 'All files compiled successfully.'
fi

java -cp $CPATH org.junit.runner.JUnitCore ./grading-area/TestListExamples > results.txt

results="$(grep 'Tests run' results.txt)"
tests_ran="$(cut -d ',' -f 1 <<< $results)"
tests_failed="$(cut -d ',' -f 2 <<< $results)"

number_ran="$(tr -d 'Tests run: ' <<< $tests_ran)"
number_failed="$(tr -d 'Failures: ' <<< $tests_failed)"

echo $results

let "number_passed = $number_failed - $number_ran"

let "grade = ($number_passed / $number_ran) * 100"

echo 'You currently have a' $grade 'on this assignment.'

exit
