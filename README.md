# shell parallel

バックグラウンドプロセス使って並列処理するサンプル


# 実行速度比較

１千万件のtsvで実験
※ リポジトリに含まれているdata.tsvは1万件です

``` shell
$ time python preprocess.py data.tsv preprocessed.tsv

real    0m12.893s
user    0m12.759s
sys     0m0.119s
```

``` shell
(base) [k-ush@lemon parallel]$ time sh parallel.sh 
/home/k-ush/parallel
input path: /home/k-ush/parallel/data.tsv
tmp.data.tsv.
********** /home/k-ush/parallel/tmp/tmp.data.tsv.00 **********
********** /home/k-ush/parallel/tmp/tmp.data.tsv.01 **********
********** /home/k-ush/parallel/tmp/tmp.data.tsv.02 **********
********** /home/k-ush/parallel/tmp/tmp.data.tsv.03 **********
out to /home/k-ush/parallel/preprocessed.tsv

real    0m4.785s
user    0m13.219s
sys     0m0.368s
```

