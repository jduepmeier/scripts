#!/bin/bash
# needs root
equery list "*" --format="[ \$location ] [\$mask] [ \$cpv ]" | grep "[\\?\\?]"
