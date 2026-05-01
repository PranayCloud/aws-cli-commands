while read user
do
  user=$(echo "$user" | tr -d '\r')   # remove Windows character
  user=$(echo "$user" | xargs)        # trim spaces
  [ -z "$user" ] && continue

  if aws iam create-user --user-name "$user"
  then
    echo "✅ Created user: $user"
  else
    echo "❌ Failed: $user"
  fi

done < useful-files-for-scripts/users.txt