#!/bin/bash

# 途中で処理がエラー吐いたら止めるための設定
set -eu

SCRIPT_DIR=$(cd $(dirname $0); pwd)
PROJECT_DIR=$SCRIPT_DIR
echo $PROJECT_DIR
cd $PROJECT_DIR

INPUT_PATH="$PROJECT_DIR/data.tsv"
OUTPUT_PATH="$PROJECT_DIR/preprocessed.tsv"
echo "input path: $INPUT_PATH"

# 分割したファイルとバックグラウンドプロセスの出力結果を入れる一時ディレクトリを作る
TMP_FILE_DIR=tmp
TMP_FILE_DIR=$PROJECT_DIR/tmp
if [ ! -d $TMP_FILE_DIR ]; then
  mkdir -p $TMP_FILE_DIR
fi

# バックグラウンドプロセスの数を決めて、何行で分割すれば良いのかを計算する
BACK_PROCESS_NUM=10
LINE_NUM=`wc -l $INPUT_PATH`
LINE_NUM=`echo $LINE_NUM | awk -F' ' '{print $1}'`
SPLIT_LINE_NUM=$(($LINE_NUM / $BACK_PROCESS_NUM))

cd $TMP_FILE_DIR

# 入力ファイルを分割するときに、分割したファイルにprefixをつける
FILENAME=`basename $INPUT_PATH`
SPLIT_PREFIX=tmp.$FILENAME.
echo $SPLIT_PREFIX

# 前に作成したものは消しとく
if ls $SPLIT_PREFIX* > /dev/null 2>&1
then
    echo "remove existing splitted files"
    rm $SPLIT_PREFIX*
fi

# ファイルを分割する。
split -d -l $SPLIT_LINE_NUM $INPUT_PATH $SPLIT_PREFIX

cd $PROJECT_DIR

# 出力ファイルのprefix
TMP_OUT_PREFIX=out
RESULT_DIR=$HOME/Que2Que-Bert/result

# 分割した全てのファイル（前に設定したprefixから始まるファイル）それぞれを入力として処理を始める
for pathfile in $TMP_FILE_DIR/$SPLIT_PREFIX*; do
    
    # 出力ファイルパスを作る
    BASE_NAME=`basename $pathfile`
    TMP_OUTPUT_PATH=$TMP_FILE_DIR/$TMP_OUT_PREFIX.$BASE_NAME

    echo "********** $pathfile **********"

    # 処理を実施する。
    python3 preprocess.py\
     --input_path $pathfile\
     --output_path $TMP_OUTPUT_PATH & 

done

wait
echo "out to $OUTPUT_PATH"
cat $TMP_FILE_DIR/$TMP_OUT_PREFIX.$SPLIT_PREFIX* > $OUTPUT_PATH
