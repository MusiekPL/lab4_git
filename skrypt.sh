#!/bin/bash

# skrypt.sh - Skrypt do laboratorium Git
# Autor: Mateusz Styk 60373
# Data: $(date +%2026-%06-%17)

SCRIPT_NAME=$(basename "$0")

show_help() {
    echo "Użycie: $SCRIPT_NAME [OPCJA] [ARGUMENT]"
    echo ""
    echo "Dostępne opcje:"
    echo "  --date,  -d           Wyświetla dzisiejszą datę"
    echo "  --logs,  -l [N]       Tworzy N plików logx.txt (domyślnie 100)"
    echo "  --error, -e [N]       Tworzy N katalogów errorx/errorx.txt (domyślnie 100)"
    echo "  --init                Klonuje repozytorium i ustawia PATH"
    echo "  --help,  -h           Wyświetla tę pomoc"
    echo ""
    echo "Przykłady:"
    echo "  $SCRIPT_NAME --date"
    echo "  $SCRIPT_NAME --logs"
    echo "  $SCRIPT_NAME --logs 30"
    echo "  $SCRIPT_NAME -l 30"
    echo "  $SCRIPT_NAME --error 30"
    echo "  $SCRIPT_NAME -e 30"
    echo "  $SCRIPT_NAME --init"
}

show_date() {
    echo "Dzisiejsza data: $(date +%Y-%m-%d)"
}

create_logs() {
    local count=${1:-100}

    if ! [[ "$count" =~ ^[0-9]+$ ]] || [ "$count" -lt 1 ]; then
        echo "Błąd: liczba plików musi być dodatnią liczbą całkowitą." >&2
        exit 1
    fi

    echo "Tworzenie $count plików logów..."
    for i in $(seq 1 "$count"); do
        local filename="log${i}.txt"
        {
            echo "Nazwa pliku: $filename"
            echo "Skrypt tworzący: $SCRIPT_NAME"
            echo "Data utworzenia: $(date '+%Y-%m-%d %H:%M:%S')"
        } > "$filename"
    done
    echo "Utworzono $count plików logów."
}

create_errors() {
    local count=${1:-100}

    if ! [[ "$count" =~ ^[0-9]+$ ]] || [ "$count" -lt 1 ]; then
        echo "Błąd: liczba plików musi być dodatnią liczbą całkowitą." >&2
        exit 1
    fi

    echo "Tworzenie $count katalogów z plikami błędów..."
    for i in $(seq 1 "$count"); do
        local dirname="error${i}"
        mkdir -p "$dirname"
        local filename="${dirname}/${dirname}.txt"
        {
            echo "Nazwa pliku: ${dirname}.txt"
            echo "Katalog: $dirname"
            echo "Skrypt tworzący: $SCRIPT_NAME"
            echo "Data utworzenia: $(date '+%Y-%m-%d %H:%M:%S')"
        } > "$filename"
    done
    echo "Utworzono $count katalogów error z plikami."
}

init_repo() {
    local REPO_URL="https://github.com/TWOJ_USERNAME/NAZWA_REPO.git"
    local TARGET_DIR="$(pwd)/repo_clone"

    echo "Klonowanie repozytorium do: $TARGET_DIR"
    git clone "$REPO_URL" "$TARGET_DIR"

    if [ $? -eq 0 ]; then
        echo "Repozytorium sklonowane pomyślnie."
        export PATH="$TARGET_DIR:$PATH"
        echo "export PATH=\"$TARGET_DIR:\$PATH\"" >> ~/.bashrc
        echo "Dodano $TARGET_DIR do zmiennej PATH."
        echo "Aby zastosować zmiany, uruchom: source ~/.bashrc"
    else
        echo "Błąd: nie udało się sklonować repozytorium." >&2
        exit 1
    fi
}

# Obsługa argumentów
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

case "$1" in
    --date|-d)
        show_date
        ;;
    --logs|-l)
        create_logs "$2"
        ;;
    --error|-e)
        create_errors "$2"
        ;;
    --init)
        init_repo
        ;;
    --help|-h)
        show_help
        ;;
    *)
        echo "Nieznana opcja: $1" >&2
        echo "Użyj '$SCRIPT_NAME --help' aby zobaczyć dostępne opcje." >&2
        exit 1
        ;;
esac
# feature: short flags -d -l -h
# feature: --init
# feature: updated help with short flags
>>>>>>> feature/help-update
