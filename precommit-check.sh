#!/bi/bash

#Перевірка чи встановлений python
if [[ "$(python3 -V)" =~ "Python 3" ]]
then
   echo "Python 3 встановлений"
else
    # Отримати назву операційної системи
    os=$(uname -s)

    # Встановити python в залежності від операційної системи
    case $os in
    Linux) # Для Linux перевірити наявність різних пакетних менеджерів
        if command -v apt &> /dev/null; then # Якщо є apt, використати його
        sudo apt update
        sudo apt install -y python3
        elif command -v dnf &> /dev/null; then # Якщо є dnf, використати його
        sudo dnf update
        sudo dnf install -y python3
        elif command -v pacman &> /dev/null; then # Якщо є pacman, використати його
        sudo pacman -Syu
        sudo pacman -S python
        else # Якщо немає жодного пакетного менеджера, вивести повідомлення про помилку
        echo "Не вдалося знайти підтримуваний пакетний менеджер"
        exit 1
        fi
        ;;
    Darwin) # Для macOS використати Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install python3
        ;;
    *) # Для інших операційних систем вивести повідомлення про помилку
        echo "Не вдалося визначити операційну систему або вона не підтримується"
        exit 1
        ;;
    esac
fi



#Скачування pre-commit
wget https://github.com/pre-commit/pre-commit/releases/download/v3.6.0/pre-commit-3.6.0.pyz
#Створення конфігу для gitleaks
cat >> ./.pre-commit-config.yaml << EOF
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: check-yaml
      - id: check-json

  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.17.0
    hooks:
      - id: gitleaks
EOF
#Оновлюємо .gitignore
echo ".pre-commit*" | cat >> .gitignore
echo "pre-commit*" | cat >> .gitignore
#Запуск pre-commit
python3 pre-commit-3.6.0.pyz
#Оновлення pre-commit
python3 pre-commit-3.6.0.pyz autoupdate
#Встановлення pre-commit
python3 pre-commit-3.6.0.pyz install
#Видалення zip архіву
rm -rf pre-commit-3.6.0.*