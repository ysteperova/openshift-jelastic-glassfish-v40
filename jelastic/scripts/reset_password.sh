include os output;

AS_ADMIN="/opt/repo/versions/4.0/bin/asadmin";
EMPTY_PASS='userproto;{SSHA256}DdW1VfFCD0AqbQFzsu6Swqel1g1gZZ6f1m87JX6FQYSpu1X/BxTX5A==;asadmin';
PASS_FILE="/opt/repo/.gfpass";

function _setPassword() {

#
# This is an example of reset password hook in Jelastic
#

        #$J_OPENSHIFT_APP_ADM_USER ; Operate this variable for the username
        #$J_OPENSHIFT_APP_ADM_PASSWORD ; Use this varible for your password

        local domain="domain1";

        [ -z "$password" ] && {
                writeJSONResponceErr "result=>4063" "message=>Password did not set";
        }

        admin_key_file="/opt/repo/versions/4.0/glassfish/domains/domain1/config/admin-keyfile";
        echo $J_OPENSHIFT_APP_ADM_PASSWORD > $PASS_FILE;
        echo $EMPTY_PASS | sed 's/userproto/admin/g' > $admin_key_file;
        echo $EMPTY_PASS | sed 's/userproto/jelastic/g' >> $admin_key_file;

        service cartridge restart;
        echo -e "AS_ADMIN_PASSWORD=\nAS_ADMIN_NEWPASSWORD=$J_OPENSHIFT_APP_ADM_PASSWORD" >> "/tmp/$$";
        $AS_ADMIN -u admin -W "/tmp/$$" change-admin-password > /dev/null 2>&1;
        #$AS_ADMIN -u admin -W "/tmp/$$"        create-file-user jelastic 
        $AS_ADMIN -u jelastic -W "/tmp/$$" change-admin-password > /dev/null 2>&1;
        #$AS_ADMIN -u admin -W "/tmp/$$" enable-secure-admin > /dev/null 2>&1;
        rm "/tmp/$$" 2>&1;
}
