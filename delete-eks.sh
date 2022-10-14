eksctl delete cluster $(eksctl get cluster --output json | jq -r '.[0].Name')
