<?php
/* For licensing terms, see /license.txt */

/**
 * Announcement Email
 *
 * @author Laurent Opprecht <laurent@opprecht.info> for the Univesity of Geneva
 * @author Julio Montoya <gugli100@gmail.com> Adding session support
 */
class AnnouncementEmail
{
    protected $course = null;
    protected $announcement = null;
    public $session_id = null;

    /**
     *
     * @param array $courseInfo
     * @param int $sessionId
     * @param int $announcementId
     *
     * @return AnnouncementEmail
     */
    public static function create($courseInfo, $sessionId, $announcementId)
    {
        return new self($courseInfo, $sessionId, $announcementId);
    }

    /**
     * @param array $courseInfo
     * @param int $sessionId
     * @param int $announcementId
     */
    public function __construct($courseInfo, $sessionId, $announcementId)
    {
        if (empty($courseInfo)) {
            $courseInfo = api_get_course_info();
        }

        $this->course = $courseInfo;
        $this->session_id = !empty($sessionId) ? (int) $sessionId : api_get_session_id();

        if (is_numeric($announcementId)) {
            $announcementId = AnnouncementManager::get_by_id($courseInfo['real_id'], $announcementId);
        }
        $this->announcement = $announcementId;
    }

    /**
     * Course info
     *
     * @param string $key
     *
     * @return string|null
     */
    public function course($key = '')
    {
        $result = $key ? $this->course[$key] : $this->course;
        $result = $key == 'id' ? intval($result) : $result;

        return $result;
    }

    /**
     * Announcement info
     *
     * @param string $key
     * @return array
     */
    public function announcement($key = '')
    {
        $result = $key ? $this->announcement[$key] : $this->announcement;
        $result = $key == 'id' ? intval($result) : $result;

        return $result;
    }

    /**
     * Returns either all course users or all session users depending on whether
     * session is turned on or not
     *
     * @return array
     */
    public function all_users()
    {
        $courseCode = $this->course('code');
        if (empty($this->session_id)) {
            $group_id = api_get_group_id();
            if (empty($group_id)) {
                $userList = CourseManager::get_user_list_from_course_code($courseCode);
            } else {
                $userList = GroupManager::get_users($group_id);
                $new_user_list = array();
                foreach ($userList as $user) {
                    $new_user_list[] = array('user_id' => $user);
                }
                $userList = $new_user_list;
            }
        } else {
            $userList = CourseManager::get_user_list_from_course_code(
                $courseCode,
                $this->session_id
            );
        }

        return $userList;
    }

    /**
     * Returns users and groups an announcement item has been sent to.
     *
     * @return array Array of users and groups to whom the element has been sent
     */
    public function sent_to_info()
    {
        $result = array();
        $result['groups'] = array();
        $result['users'] = array();

        $table = Database::get_course_table(TABLE_ITEM_PROPERTY);
        $tool = TOOL_ANNOUNCEMENT;
        $id = $this->announcement('id');
        $course_id = $this->course('real_id');
        $sessionCondition = api_get_session_condition($this->session_id);

        $sql = "SELECT to_group_id, to_user_id
                FROM $table
                WHERE
                    c_id = $course_id AND
                    tool = '$tool' AND
                    ref = $id
                    $sessionCondition";

        $rs = Database::query($sql);

        while ($row = Database::fetch_array($rs, 'ASSOC')) {
            // if to_user_id <> 0 then it is sent to a specific user
            $user_id = $row['to_user_id'];
            if (!empty($user_id)) {
                $result['users'][] = (int) $user_id;
                // If user is set then skip the group
                continue;
            }

            // if to_group_id is null then it is sent to a specific user
            // if to_group_id = 0 then it is sent to everybody
            $group_id = $row['to_group_id'];
            if (!empty($group_id)) {
                $result['groups'][] = (int) $group_id;
            }
        }

        return $result;
    }

    /**
     * Returns the list of user info to which an announcement was sent.
     * This function returns a list of actual users even when recipient
     * are groups
     *
     * @return array
     */
    public function sent_to()
    {
        $sent_to = $this->sent_to_info();
        $users = $sent_to['users'];
        $users = $users ? $users : array();
        $groups = $sent_to['groups'];

        if ($users) {
            $users = UserManager::get_user_list_by_ids($users, true);
        }

        if (!empty($groups)) {
            $groupUsers = GroupManager::get_groups_users($groups);
            $groupUsers = UserManager::get_user_list_by_ids($groupUsers, true);

            if (!empty($groupUsers)) {
                $users = array_merge($users, $groupUsers);
            }
        }

        if (empty($users)) {
            $users = self::all_users();
        }

        // Clean users just in case
        $newListUsers = [];
        if (!empty($users)) {
            foreach ($users as $user) {
                $newListUsers[$user['user_id']] = ['user_id' => $user['user_id']];
            }
        }

        return $newListUsers;
    }

    /**
     * Sender info
     *
     * @param string $key
     *
     * @return array
     */
    public function sender($key = '', $userId = '')
    {
        $_user = api_get_user_info($userId);

        return $key ? $_user[$key] : $_user;
    }

    /**
     * Email subject
     *
     * @return string
     */
    public function subject()
    {
        $result = $this->announcement('title');
        $result = stripslashes($result);

        return $result;
    }

    /**
     * Email message
     * @param int $receiverUserId
     *
     * @return string
     */
    public function message($receiverUserId)
    {
        $content = $this->announcement('content');
        $session_id = $this->session_id;
        $courseCode = $this->course('code');

        $content = AnnouncementManager::parse_content(
            $receiverUserId,
            $content,
            $courseCode,
            $session_id
        );

        $user_email = $this->sender('mail');
        // Build the link by hand because api_get_cidreq() doesn't accept course params
        $course_param = 'cidReq='.$courseCode.'&id_session='.$session_id.'&gidReq='.api_get_group_id();
        $course_name = $this->course('title');

        $result = "<div>$content</div>";

        // Adding attachment
        $attachment = $this->attachment();
        if (!empty($attachment)) {
            $result .= '<br />';
            $result .= Display::url(
                $attachment['filename'],
                api_get_path(WEB_CODE_PATH).'announcements/download.php?file='.basename($attachment['path']).'&'.$course_param
            );
            $result .= '<br />';
        }

        $result .= '<hr />';
        $sender_name = api_get_person_name(
            $this->sender('firstName'),
            $this->sender('lastName'),
            PERSON_NAME_EMAIL_ADDRESS
        );
        $result .= '<a href="mailto:'.$user_email.'">'.$sender_name.'</a><br/>';
        $result .= '<a href="'.api_get_path(WEB_CODE_PATH).'announcements/announcements.php?'.$course_param.'">'.$course_name.'</a><br/>';

        return $result;
    }

    /**
     * Returns the one file that can be attached to an announcement.
     *
     * @return array
     */
    public function attachment()
    {
        $result = array();
        $table = Database::get_course_table(TABLE_ANNOUNCEMENT_ATTACHMENT);
        $id = $this->announcement('id');
        $course_id = $this->course('id');
        $sql = "SELECT * FROM $table 
                WHERE c_id = $course_id AND announcement_id = $id ";
        $rs = Database::query($sql);
        $course_path = $this->course('directory');
        while ($row = Database::fetch_array($rs)) {
            $path = api_get_path(SYS_COURSE_PATH).$course_path.'/upload/announcements/'.$row['path'];
            $filename = $row['filename'];
            $result[] = array('path' => $path, 'filename' => $filename);
        }

        $result = $result ? reset($result) : array();

        return $result;
    }

    /**
     * Send emails to users.
     * @param bool $sendToUsersInSession
     * @param bool $sendToDrhUsers send a copy of the message to the DRH users
     * related to the main user
     */
    public function send($sendToUsersInSession = false, $sendToDrhUsers = false)
    {
        $sender = $this->sender();
        $subject = $this->subject();

        // Send email one by one to avoid antispam
        $users = $this->sent_to();

        $batchSize = 20;
        $counter = 1;
        $em = Database::getManager();

        foreach ($users as $user) {
            $message = $this->message($user['user_id']);
            MessageManager::send_message_simple(
                $user['user_id'],
                $subject,
                $message,
                $sender['user_id'],
                $sendToDrhUsers,
                true
            );

            if (($counter % $batchSize) === 0) {
                $em->flush();
                $em->clear();
            }
            $counter++;
        }

        if ($sendToUsersInSession) {
            $sessionList = SessionManager::get_session_by_course($this->course['real_id']);
            if (!empty($sessionList)) {
                foreach ($sessionList as $sessionInfo) {
                    $sessionId = $sessionInfo['id'];
                    $message = $this->message(null);
                    $userList = CourseManager::get_user_list_from_course_code(
                        $this->course['code'],
                        $sessionId
                    );
                    if (!empty($userList)) {
                        foreach ($userList as $user) {
                            MessageManager::send_message_simple(
                                $user['user_id'],
                                $subject,
                                $message,
                                $sender['user_id'],
                                false,
                                true
                            );
                        }
                    }
                }
            }
        }

        $this->log_mail_sent();
    }

    /**
     * Store that emails where sent
     */
    public function log_mail_sent()
    {
        $id = $this->announcement('id');
        $course_id = $this->course('id');

        $table = Database::get_course_table(TABLE_ANNOUNCEMENT);
        $sql = "UPDATE $table SET 
                email_sent = 1
                WHERE 
                    c_id = $course_id AND 
                    id = $id AND 
                    session_id = {$this->session_id} 
                ";
        Database::query($sql);
    }
}
