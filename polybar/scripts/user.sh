#!/usr/bin/env bash
# Shows manufacturer + product model (Dell OptiPlex 3080)
VENDOR=$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null | tr -d '\0' | xargs)
MODEL=$(cat /sys/class/dmi/id/product_name 2>/dev/null | tr -d '\0' | xargs)

if [ -n "$VENDOR" ] && [ -n "$MODEL" ]; then
    TEXT="${VENDOR} ${MODEL}"
elif [ -n "$MODEL" ]; then
    TEXT="$MODEL"
else
    TEXT="Unknown Hardware"
fi

color="#ffffff"
echo "%{F$color}%{T3}${TEXT}%{T-}%{F-}  "
