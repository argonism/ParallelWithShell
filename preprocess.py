import random

# ランダムに入力テキストの1文字をマスクする関数
def mask_random_char(msg: str) -> str:
    rand_idx = random.randrange(len(msg))
    msg = msg[:rand_idx] + "[MASK]" + msg[rand_idx+1:]
    return msg

def preprocess(input_path: str, output_path: str) -> None:
    with open(input_path) as f, open(output_path, "w") as fw:
        for line in f:
            i, msg = line.strip().split("\t")
            output_line = f"{i}\t{mask_random_char(msg)}\n"
            fw.write(output_line)

if __name__ == "__main__":
    from argparse import ArgumentParser
    parser = ArgumentParser(description='demo code for parallel execution in bash script')
    parser.add_argument('input_path')
    parser.add_argument('output_path')
    
    args, other = parser.parse_known_args()

    preprocess(args.input_path, args.output_path)