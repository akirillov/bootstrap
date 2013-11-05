current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

redis-server ${current_dir}/redis.conf &
