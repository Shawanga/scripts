#!/bin/zsh

# Example usage:
# ./wd_list_to_hash.sh passwords.txt

# Input wordlist
wordlist_file="$1"

# Create hashed_passwords.txt
: > hashed_passwords.txt

# Read each password from the file, hash it with SHA-256, and write to hashed_passwords.txt
while read -r password; do
    echo -n "$password" | openssl dgst -sha256 | awk '{print $2}' >> hashed_passwords.txt
done < "$wordlist_file"

echo "Complete."
