#!/usr/bin/env bash
set -u

#
# Version
#
MY_VERSION="0.18"
MY_DATE="2022-20-28"

#
# Credits
#
MY_AUTHOR="cytopia"
MY_EMAIL="cytopia@everythingcli.org"

#
# Required system binaries
#
REQUIRED_BINS="awk grep find sed tr xargs"

#
# Variables populated by cmd args or config file
#
MY_PATH=
MY_SHE=
MY_EXT=0
MY_IGN=
MY_TXT=0
MY_SIZ=0
MY_DRY=0
MY_LST=0
MY_VER=0
MY_DEB=0
MY_FIX=0
MY_CFG=
MY_CUS=

CLR_SUC="\033[0;32m"
CLR_ERR="\033[0;31m"
CLR_CLS="\033[0m"

################################################################################
#
#  F U N C T I O N S
#
################################################################################



print_usage() {

	if [ "${ENABLE_CUST_OPS}" = "1" ];then
		_custom=" [--custom \"opts\"]"
	else
		_custom=""
	fi

	if [ "${ENABLE_FIX}" = "1" ];then
		_fix=" [--fix]"
	else
		_fix=""
	fi

	echo "Usage: ${MY_NAME} [--text] [--size] [--shebang <ARG>] [--extension \"tpl,htm,html,php,...\"] [--ignore \"dir1,dir2\"] [--config \"conf\"] [--confpre \"${MY_CONF_PRE}\"]${_custom}${_fix} [--verbose] [--debug] [--dry] [--list] --path <DIR>"
	echo "       ${MY_NAME} --info"
	echo "       ${MY_NAME} --help"
	echo "       ${MY_NAME} --version"
	echo
	echo "${MY_DESC}"
	echo "Will return 1 on occurance, otherwise 0."
	echo
	echo "Required arguments:"
	echo
	echo "  --path <ARG>       Specify directory where to scan."
	echo
	echo
	echo "Optional run arguments:"
	if [ "${ENABLE_FIX}" = "1" ];then
		echo "  --fix              Fixable :-)"
		echo "                     Fix the problems for the specified files."
		echo "                     Note, all other options below also apply"
		echo
	fi
	echo "  --text             Limit search to text files only (non-binary)."
	echo "                     Can be narrowed further with '--extension'"
	echo
	echo "  --size             Limit search to files which are not empty (bigger than 0 bytes)."
	echo
	echo "  --shebang <ARG>    Only find files (shell scripts) with this specific shebang."
	echo "                     It is useful to combine this with --text and --size for faster searches."
	echo "                     Use with --dry to see how this search command is generated."
	echo "                     Example:"
	echo "                         --shebang bash"
	echo "                         --shebang php"
	echo "                         --shebang sh"
	echo
	echo "  --extension <ARG>  Only find files matching those extensions."
	echo "                     Comma separated list of file extensions."
	echo "                     Only find files matching those extensions."
	echo "                     Defaults to all files if not specified or empty."
	echo "                     Example:"
	echo "                         --extension \"html,php,inc\""
	echo "                         --extension php"
	echo
	echo "  --ignore <ARG>     Comma separated list of ignore paths."
	echo "                     Directories must be specified from the starting location of --path."
	echo "                     Example:"
	echo "                          ignore 'foor/bar' folder inside '/var/www' path:"
	echo "                         --path /var/www --ignore foo/bar"
	echo
	echo "  --config <ARG>     Load configuration file."
	echo "                     File must contain the following directives:"
	echo "                         ${MY_CONF_PRE}EXTENSION=\"\" # comma separated"
	echo "                         ${MY_CONF_PRE}IGNORE=\"\"    # comma separated"
	echo "                         ${MY_CONF_PRE}TEXT=0|1     # 0 or 1"
	if [ "${ENABLE_CUST_OPS}" = "1" ];then
		echo "                         ${MY_CONF_PRE}CUSTOM=\"\"    # custom command"
	fi
	echo "                     Note that cmd arguments take precedence over"
	echo "                     config file settings."
	echo
	echo "  --confpre <ARG>    Set custom configuration directive prefix."
	echo "                     Current default ist: '${MY_CONF_PRE}'."
	echo "                     This is useful, when you want to define different defaults"
	echo "                     per check via configuration file."
	echo
	if [ "${ENABLE_CUST_OPS}" = "1" ];then
		echo "  --custom <ARG>     Parse custom command line option to the check binary."
		echo "                     Note that when you want to add config files or other files"
		echo "                     you must use an absolute path."
		echo
		echo "                     Current custom command:"
		echo "                          --custom \"${DEFAULT_CUST_OPS//\"/\\\"}\"" # \" -> \\\"
		echo
		echo "                     Overwrite example:"
		echo "                          --custom \"--color --config /absoulte/path/conf.json\""
		echo
	fi
	echo "  --verbose          Be verbose and print commands and files being checked."
	echo
	echo
	echo "  --debug            Print system messages."
	echo
	echo
	echo "Optional training arguments:"
	echo "  --dry              Don't do anything, just display the commands."
	echo
	echo "  --list             Instead of searching inside the files, just display the filenames"
	echo "                     that would be found by --path, --extension and --ignore"
	echo
	echo
	echo "System arguments:"
	echo "  --info             Show versions of required commands (useful for bugreports)."
	echo "  --help             Show help screen."
	echo "  --version          Show version information."
	echo
	echo
	echo "${MY_NAME} is part of the awesome-ci collection."
	echo "https://github.com/cytopia/awesome-ci"
}

print_version() {
	echo "tool:    ${MY_NAME}"
	echo "version: v${MY_VERSION} (${MY_DATE})"
	echo "author:  ${MY_AUTHOR}"
	echo "email:   ${MY_EMAIL}"
	echo
	echo "${MY_NAME} is part of the awesome-ci collection."
	echo "https://github.com/cytopia/awesome-ci"
}

print_info() {

	#
	# Required binaries
	#

	if ! echo "${MY_INFO}" | grep -cqE "^bash"; then
		MY_CMD_VERSION="bash --version | grep -E '(([0-9]+)(\.))+'"
		echo "\$ ${MY_CMD_VERSION}"
		eval "${MY_CMD_VERSION}"
		echo
	fi
	if ! echo "${MY_INFO}" | grep -cqE "^\(awk"; then
		MY_CMD_VERSION="(awk -Wversion 2>/dev/null || awk --version 2>&1) | grep -E '(([0-9]+)(\.))+'"
		echo "\$ ${MY_CMD_VERSION}"
		eval "${MY_CMD_VERSION}"
		echo
	fi
	if ! echo "${MY_INFO}" | grep -cqE "^grep"; then
		MY_CMD_VERSION="grep -V | grep -E '([0-9]+\.+)+'"
		echo "\$ ${MY_CMD_VERSION}"
		eval "${MY_CMD_VERSION}"
		echo
	fi
	if ! echo "${MY_INFO}" | grep -cqE "^\(find"; then
		MY_CMD_VERSION="(find --version >/dev/null 2>&1) && (find --version 2>&1 | head -1) || (echo 'find (BSD find)')"
		echo "\$ ${MY_CMD_VERSION}"
		eval "${MY_CMD_VERSION}"
		echo
	fi
	if ! echo "${MY_INFO}" | grep -cqE "^\(sed"; then
		MY_CMD_VERSION="(sed --version >/dev/null 2>&1) && (sed --version 2>&1 | head -1) || (echo 'sed (BSD sed)')"
		echo "\$ ${MY_CMD_VERSION}"
		eval "${MY_CMD_VERSION}"
		echo
	fi
	if ! echo "${MY_INFO}" | grep -cqE "^\(tr"; then
		MY_CMD_VERSION="(tr --version >/dev/null 2>&1) && (tr --version 2>&1 | head -1) || (echo 'tr (BSD tr)')"
		echo "\$ ${MY_CMD_VERSION}"
		eval "${MY_CMD_VERSION}"
		echo
	fi
	if ! echo "${MY_INFO}" | grep -cqE "^\(xargs"; then
		MY_CMD_VERSION="(xargs --version >/dev/null 2>&1) && (xargs --version 2>&1 | head -1) || (echo 'xargs (BSD xargs)')"
		echo "\$ ${MY_CMD_VERSION}"
		eval "${MY_CMD_VERSION}"
		echo
	fi

	#
	# Custom binary
	#
	if [ "${MY_INFO}" != "" ]; then
		echo "\$ ${MY_INFO}"
		eval "${MY_INFO}"
		echo
	fi

	#
	# --fix binary
	#
	if [ "${ENABLE_FIX}" = "1" ] && [ "${REQUIRED_FIX_BINS}" != "" ]; then
		_can_fix="1"
		for _bin in ${REQUIRED_FIX_BINS}; do
			if ! command -v "${_bin}" >/dev/null 2>&1; then
				echo "${_bin}: Not found."
				_can_fix="0}"
			fi
		done
		if [ "${_can_fix}" = "1" ]; then
			echo "\$ ${MY_FIX_INFO}"
			eval "${MY_FIX_INFO}"
			echo
		else
			echo "Unable to use --fix"
			echo
			return 0
		fi
	fi
}


check_requirements() {
	_debug="${1}"
	_ret1=0
	_ret2=0

	# System binaries
	for _bin in ${REQUIRED_BINS}; do
		if ! command -v "${_bin}" >/dev/null 2>&1; then
			echo "[ERR] Required sys binary '${_bin}' not found."
			_ret1=1
		else
			if [ "${_debug}" = "1" ]; then
				echo "[OK]  Required system binary '${_bin}' found."
			fi
		fi
	done

	# Specific binaries for this check
	for _bin in ${REQUIRED_CUST_BINS}; do
		if ! command -v "${_bin}" >/dev/null 2>&1; then
			echo "[ERR] Required custom binary '${_bin}' not found."
			_ret2=1
		else
			if [ "${_debug}" = "1" ]; then
				echo "[OK]  Required custom binary '${_bin}' found."
			fi
		fi
	done

	# Binaries required to fix
	if [ "${ENABLE_FIX}" = "1" ] && [ "${MY_FIX}" = "1" ]; then
		for _bin in ${REQUIRED_FIX_BINS}; do
			if ! command -v "${_bin}" >/dev/null 2>&1; then
				echo "[ERR] Required --fix binary '${_bin}' not found."
				_ret2=1
			else
				if [ "${_debug}" = "1" ]; then
					echo "[OK]  Required --fix binary '${_bin}' found."
				fi
			fi
		done
	fi


	return $((_ret1 + _ret2))
}

check_config_file() {
	_config="${1}"

	# Check config file
	if [ ! -f "${_config}" ]; then
		echo "[CONFIG] Config file not found: ${_config}"
		return 1
	fi

	# Check directives
	if ! grep -Eq "^${MY_CONF_PRE}IGNORE=" "${_config}"; then
		echo "[CONFIG] ${MY_CONF_PRE}IGNORE variable not found in config."
		return 1
	fi
	if ! grep -Eq "^${MY_CONF_PRE}IGNORE=[\"']{1}.*[\"']{1}$" "${_config}"; then
		echo "[CONFIG] Invalid syntax for ${MY_CONF_PRE}IGNORE variable."
		return 1
	fi
	if ! grep -Eq "^${MY_CONF_PRE}EXTENSION=" "${_config}"; then
		echo "[CONFIG] ${MY_CONF_PRE}EXTENSION variable not found in config."
		return 1
	fi
	if ! grep -Eq "^${MY_CONF_PRE}EXTENSION=[\"']{1}.*[\"']{1}$" "${_config}"; then
		echo "[CONFIG] Invalid syntax for ${MY_CONF_PRE}EXTENSION variable."
		return 1
	fi
	if ! grep -Eq "^${MY_CONF_PRE}TEXT=" "${_config}"; then
		echo "[CONFIG] ${MY_CONF_PRE}TEXT variable not found in config."
		return 1
	fi
	if ! grep -Eq "^${MY_CONF_PRE}TEXT=[\"']*[01]{1}[\"']*$" "${_config}"; then
		echo "[CONFIG] Invalid syntax for ${MY_CONF_PRE}TEXT variable."
		return 1
	fi

	# Check optional directives
	if [ "${ENABLE_CUST_OPS}" = "1" ]; then
		if ! grep -Eq "^${MY_CONF_PRE}CUSTOM=[\"']{1}.*[\"']{1}$" "${_config}"; then
			echo "[CONFIG] Invalid syntax for ${MY_CONF_PRE}CUSTOM variable."
			return 1
		fi
	fi

}


#
# System independent method
# to get number of CPU cores.
# (defaults to 1 if impossible)
#
num_cpu() {
	if ! _num="$( getconf _NPROCESSORS_ONLN 2>/dev/null )"; then
		echo "1"
	else
		echo "${_num}"
	fi
}


#
# sed wrapper that automatically escapes
# regex literals
#
mysed() {
	_input="$1"
	_search="$2"
	_replace="$3"

	echo "${_input}" | sed "s/$(echo "${_search}" | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo "${_replace}" | sed -e 's/[\/&]/\\&/g')/g"
}




################################################################################
#
#  M A I N   E N T R Y   P O I N T
#
################################################################################



############################################################
# Command Line arguments
############################################################


#
# Read command line arguments
#
while [ $# -gt 0  ]; do
	case "${1}" in

		# ----------------------------------------
		--path)
			shift
			MY_PATH="${1}"
			;;

		# ----------------------------------------
		--shebang)
			shift
			MY_SHE="${1}"
			;;

		# ----------------------------------------
		--extension)
			shift
			MY_EXT="${1}"
			;;

		# ----------------------------------------
		--ignore)
			shift
			MY_IGN="${1}"
			;;

		# ----------------------------------------
		--config)
			shift
			MY_CFG="${1}"
			;;

		# ----------------------------------------
		--confpre)
			shift
			MY_CONF_PRE="${1}"
			;;

		# ----------------------------------------
		--custom)
			if [ "${ENABLE_CUST_OPS}" = "1" ]; then
				shift
				MY_CUS="${1}"
			else
				echo "Invalid argument: ${1}"
				echo "Type '${MY_NAME} --help' for available options."
				exit 1
			fi
			;;

		# ----------------------------------------
		--fix)
			if [ "${ENABLE_FIX}" = "1" ]; then
				MY_FIX=1
			else
				echo "Invalid argument: ${1}"
				echo "Type '${MY_NAME} --help' for available options."
				exit 1
			fi
			;;


		# ----------------------------------------
		--text)
			MY_TXT=1
			;;

		# ----------------------------------------
		--size)
			MY_SIZ=1
			;;

		# ----------------------------------------
		--dry)
			MY_DRY=1
			;;

		# ----------------------------------------
		--list)
			MY_LST=1
			;;

		# ----------------------------------------
		--verbose)
			MY_VER=1
			;;

		# ----------------------------------------
		--debug)
			MY_DEB=1
			;;

		# ----------------------------------------
		--info)
			if ! check_requirements "${MY_DEB}"; then
				exit 1
			fi

			if ! print_info; then
				exit 1
			fi

			exit 0
			;;

		# ----------------------------------------
		--help)
			print_usage
			exit 0
			;;

		# ----------------------------------------
		--version)
			print_version
			exit 0
			;;

		# ----------------------------------------
		*)
			echo "Invalid argument: ${1}"
			echo "Type '${MY_NAME} --help' for available options."
			exit 1
			;;
	esac
	shift
done



############################################################
# Sanity Checks
############################################################

#
# Check general requirements
#
if ! check_requirements "${MY_DEB}"; then
	exit 1
fi

#
# Check path
#
if [ "${MY_PATH}" = "" ]; then
	echo "--path not specified"
	echo "Type '${MY_NAME} --help' for available options."
	exit 1
fi
if [ ! -e "${MY_PATH}" ]; then
	echo "Specified path does not exist: '${MY_PATH}'."
	echo "Type '${MY_NAME} --help' for available options."
	exit 1
fi


#
# Check and load config if desired
#
if [ "${MY_CFG}" != "" ]; then
	if ! check_config_file "${MY_CFG}"; then
		exit 1
	fi

	. "${MY_CFG}"
fi



############################################################
# Evaluate Settings
############################################################

CPU_CORES="$(num_cpu)"


# Var substitutions for config file directives
# to match current program.
EXTENSION="${MY_CONF_PRE}EXTENSION"
IGNORE="${MY_CONF_PRE}IGNORE"
TEXT="${MY_CONF_PRE}TEXT"
SIZE="${MY_CONF_PRE}SIZE"
CUSTOM="${MY_CONF_PRE}CUSTOM"

#
# Decide on Shebang
#
if [ "${MY_SHE}" != "" ]; then
	MY_SHE="xargs -0 -P ${CPU_CORES} -n1 awk '/^#!.*(\/${MY_SHE}|[[:space:]]+${MY_SHE})/{print FILENAME}'"
else
	MY_SHE=""
fi



#
# Decide on File extensions
#
if [ "${MY_CFG}" != "" ] && [ "${MY_EXT}" != "0" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Cmd arg --extension=${MY_EXT} will take precedence over config file value".
	fi
	MY_EXT="${MY_EXT}"

elif [ "${MY_CFG}" != "" ] && [ "${MY_EXT}" = "0" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Using config file values: ext: ${!EXTENSION}"
	fi
	MY_EXT="${!EXTENSION}"

elif [ "${MY_CFG}" = "" ] && [ "${MY_EXT}" != "0" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Using cmd argument: ext: '${MY_EXT}'"
	fi
	MY_EXT="${MY_EXT}"

else
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Using all file extensions"
	fi
	MY_EXT=
fi


#
# Decide on ignore paths
#
if [ "${MY_CFG}" != "" ] && [ "${MY_IGN}" != "" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Cmd arg --ignore=${MY_IGN} will take precedence over config file value".
	fi
	MY_IGN="${MY_IGN}"

elif [ "${MY_CFG}" != "" ] && [ "${MY_IGN}" = "" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Using config file values: ignore: ${!IGNORE}"
	fi
	MY_IGN="${!IGNORE}"

elif [ "${MY_CFG}" = "" ] && [ "${MY_IGN}" != "" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Using cmd argument: ignore: ${MY_IGN}"
	fi
	MY_IGN="${MY_IGN}"

else
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Not ignoring anything"
	fi
	MY_IGN=
fi


#
# Decide on text files (non-binary) or all files
#
if [ "${MY_CFG}" != "" ] && [ "${MY_TXT}" != "0" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Cmd arg --text: '${MY_TXT}' will take precedence over config file value".
	fi
	MY_TXT="${MY_TXT}"

elif [ "${MY_CFG}" != "" ] && [ "${MY_TXT}" = "0" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Using config file values: --text: ${!TEXT}"
	fi
	MY_TXT="${!TEXT}"

elif [ "${MY_CFG}" = "" ] && [ "${MY_TXT}" != "0" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Using cmd argument: --text: ${MY_TXT}"
	fi
	MY_TXT="${MY_TXT}"

else
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Not narrowing down by text files"
	fi
	MY_TXT="0"
fi


#
# Decide on file size
#
if [ "${MY_CFG}" != "" ] && [ "${MY_SIZ}" != "0" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Cmd arg --size: '${MY_SIZ}' will take precedence over config file value".
	fi
	MY_SIZ="${MY_SIZ}"

elif [ "${MY_CFG}" != "" ] && [ "${MY_SIZ}" = "0" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Using config file values: --size: ${!SIZE}"
	fi
	MY_SIZ="${!SIZE}"

elif [ "${MY_CFG}" = "" ] && [ "${MY_SIZ}" != "0" ]; then
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Using cmd argument: --size: ${MY_SIZ}"
	fi
	MY_SIZ="${MY_SIZ}"

else
	if [ "${MY_DEB}" = "1" ]; then
		echo "[ARG] Not narrowing down by size > 0 bytes"
	fi
	MY_SIZ="0"
fi

if [ "${MY_SIZ}" = "1" ]; then
	MY_SIZ="! -size 0"
else
	MY_SIZ=""
fi



#
# Decide on Custom string
#
if [ "${ENABLE_CUST_OPS}" = "1" ]; then
	if [ "${MY_CFG}" != "" ] && [ "${MY_CUS}" != "" ]; then
		if [ "${MY_DEB}" = "1" ]; then
			echo "[ARG] Cmd arg --custom \"${MY_CUS}\" will take precedence over config file value".
		fi
		MY_CUS="${MY_CUS}"

	elif [ "${MY_CFG}" != "" ] && [ "${MY_CUS}" = "" ]; then
		if [ "${MY_DEB}" = "1" ]; then
			echo "[ARG] Using config file values: custom: \"${!CUSTOM}\""
		fi
		MY_CUS="${!CUSTOM}"

	elif [ "${MY_CFG}" = "" ] && [ "${MY_CUS}" != "" ]; then
		if [ "${MY_DEB}" = "1" ]; then
			echo "[ARG] Using cmd argument: custom: \"${MY_CUS}\""
		fi
		MY_CUS="${MY_CUS}"

	else
		if [ "${MY_DEB}" = "1" ]; then
			echo "[ARG] No customization applied"
		fi
		MY_CUS=
	fi
fi



############################################################
# Build command
############################################################

#
# 'find' pattern for file extensions
#
if [ "${MY_EXT}" != "" ]; then
	NAME_PATTERN="\( -iname \*.${MY_EXT//,/ -o -iname \\*.} \)"
else
	NAME_PATTERN=""
fi

#
# 'find' pattern for ignores/excludes
#
if [ "${MY_IGN}" != "" ]; then
	EXCL_PATTERN="-not \( -path \"${MY_PATH}/${MY_IGN//,/*\" -o -path \"${MY_PATH}\/}*\" \)"
else
	EXCL_PATTERN=""
fi


#
# Fix?
#
if [ "${MY_FIX}" = "1" ]; then
	MY_CHECK="${MY_FIX_CMD}"
else
	#
	# Normal check
	# (Apply custom command?)
	#
	if [ "${MY_CUS}" = "" ]; then
		MY_CHECK="$( mysed "${MY_CHECK}" "__CUSTOM_OPT_PLACEHOLDER__" "${DEFAULT_CUST_OPS}" )"
	else
		MY_CHECK="$( mysed "${MY_CHECK}" "__CUSTOM_OPT_PLACEHOLDER__" "${MY_CUS}" )"
	fi
fi


#
# Show files or grep in found files?
#


# Be verbose?
if [ "${MY_VER}" = "1" ]; then
	XARGS_VERBOSE="-t"
else
	XARGS_VERBOSE=""
fi

#
# Build command
#


### Text files (list-only)
if [ "${MY_TXT}" = "1" ] && [ "${MY_LST}" = "1" ]; then
	if [ "${MY_SHE}" != "" ]; then
		MY_CMD="find ${MY_PATH} -type f ${NAME_PATTERN} ${EXCL_PATTERN} ${MY_SIZ} -print0 | xargs -0 -P ${CPU_CORES} -n1 grep -Il '' | tr '\n' '\0' | ${MY_SHE}"
	else
		MY_CMD="find ${MY_PATH} -type f ${NAME_PATTERN} ${EXCL_PATTERN} ${MY_SIZ} -print0 | xargs -0 -P ${CPU_CORES} -n1 grep -Il ''"
	fi

### Text files (run!!!)
elif [ "${MY_TXT}" = "1" ] && [ "${MY_LST}" = "0" ]; then
	if [ "${MY_SHE}" != "" ]; then
		MY_CMD="find ${MY_PATH} -type f ${NAME_PATTERN} ${EXCL_PATTERN} ${MY_SIZ} -print0 | xargs -0 -P ${CPU_CORES} -n1 grep -Il '' | tr '\n' '\0' | ${MY_SHE} | tr '\n' '\0' | xargs -0 -P ${CPU_CORES} -n1 ${XARGS_VERBOSE} sh -c 'if [ -f \"\${1}\" ]; then ${MY_CHECK}; fi' --"
	else
		MY_CMD="find ${MY_PATH} -type f ${NAME_PATTERN} ${EXCL_PATTERN} ${MY_SIZ} -print0 | xargs -0 -P ${CPU_CORES} -n1 grep -Il '' | tr '\n' '\0' | xargs -0 -P ${CPU_CORES} -n1 ${XARGS_VERBOSE} sh -c 'if [ -f \"\${1}\" ]; then ${MY_CHECK}; fi' --"
	fi

### All files (list-only)
elif [ "${MY_TXT}" = "0" ] && [ "${MY_LST}" = "1" ]; then
	if [ "${MY_SHE}" != "" ]; then
		MY_CMD="find ${MY_PATH} -type f ${NAME_PATTERN} ${EXCL_PATTERN} ${MY_SIZ} -print0 | ${MY_SHE}"
	else
		MY_CMD="find ${MY_PATH} -type f ${NAME_PATTERN} ${EXCL_PATTERN} ${MY_SIZ} -print"
	fi


### All files (run!!!)
else
	if [ "${MY_SHE}" != "" ]; then
		MY_CMD="find ${MY_PATH} -type f ${NAME_PATTERN} ${EXCL_PATTERN} ${MY_SIZ} -print0 | ${MY_SHE} | tr '\n' '\0' | xargs -0 -P ${CPU_CORES} -n1 ${XARGS_VERBOSE} sh -c 'if [ -f \"\${1}\" ]; then ${MY_CHECK}; fi' --"
	else
		MY_CMD="find ${MY_PATH} -type f ${NAME_PATTERN} ${EXCL_PATTERN} ${MY_SIZ} -print0 | xargs -0 -P ${CPU_CORES} -n1 ${XARGS_VERBOSE} sh -c 'if [ -f \"\${1}\" ]; then ${MY_CHECK}; fi' --"
	fi

fi




############################################################
# Execute
############################################################

# Dry mode?
if [ "${MY_DRY}" = "1" ]; then
	printf "%s\n" "${MY_CMD}"
	exit 0
fi

printf "\$ %s\n" "${MY_CMD}"

output="$(eval "${MY_CMD}")"

# If showing files only, exit normally
if [ "${MY_LST}" = "1" ]; then
	printf "%s\n" "${output}"
	exit 0
fi


if [ "${output}" != "" ]; then
	printf "%s\n" "${output}"
	printf "${CLR_ERR}[ERR] %s${CLR_CLS}\n" "${MY_FINISH_ERR}"
	exit 1
else
	printf "${CLR_SUC}[OK]  %s${CLR_CLS}\n" "${MY_FINISH_OK}"
	exit 0
fi
