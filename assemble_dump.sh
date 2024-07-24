#!/bin/bash

# 遍历当前目录下的所有 .txt 文件
for file in *.txt; do
    # 检查是否存在 .txt 文件
    if [ -e "$file" ]; then
        # 提取文件名（不含扩展名）
        filename=$(basename "$file" .txt)
        # 执行命令
        java -jar ./Mars4_5.jar a dump .text HexText "$filename.hextext" "$file"
        sed '1i memory_initialization_radix = 16;\nmemory_initialization_vector =' "$filename.hextext" > "$filename.coe"
        echo "dumped hextext and coe: $file"

        echo "getting register message"
        java -jar ./Mars4_5.jar $file
        if [[ -e "result.txt" ]];then
            echo "find result.txt, change name to $filename.result"
            mv ./result.txt "$filename.result"
        fi
    else
        echo "没有找到 .txt 文件."
    fi
done

