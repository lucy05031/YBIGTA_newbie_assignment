
# anaconda(또는 miniconda)가 존재하지 않을 경우 설치해주세요!
## TODO
if ! command -v conda &> /dev/null; then
    echo "[INFO] conda가 없어 Miniconda를 설치합니다."
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -b -p "$HOME/miniconda"
    export PATH="$HOME/miniconda/bin:$PATH"
fi

CONDA_BASE=$(conda info --base)
source "$CONDA_BASE/etc/profile.d/conda.sh"

# Conda 환셩 생성 및 활성화
## TODO
if ! conda env list | grep -q "myenv"; then
    conda create -n myenv python=3.10 -y
fi
conda activate myenv

## 건드리지 마세요! ##
python_env=$(python -c "import sys; print(sys.prefix)")
if [[ "$python_env" == *"/envs/myenv"* ]]; then
    echo "[INFO] 가상환경 활성화: 성공"
else
    echo "[INFO] 가상환경 활성화: 실패"
    exit 1 
fi

# 필요한 패키지 설치
## TODO
pip install mypy

# Submission 폴더 파일 실행
cd submission || { echo "[INFO] submission 디렉토리로 이동 실패"; exit 1; }

for file in *.py; do
    ## TODO
    problem_num="${file#*_}"
    problem_num="${problem_num%.py}"
    input_file="../input/${problem_num}_input"
    output_file="../output/${problem_num}_output"

    if [ -f "$input_file" ]; then
        python "$file" < "$input_file" > "$output_file"
        echo "[INFO] $file 실행 완료 -> $output_file"
    else
        echo "[WARN] $input_file 없음, $file 건너뜀"
    fi
done

# mypy 테스트 실행 및 mypy_log.txt 저장
## TODO
mypy *.py > ../mypy_log.txt 2>&1

# conda.yml 파일 생성
## TODO
conda env export -n myenv > ../conda.yml

# 가상환경 비활성화
## TODO
conda deactivate