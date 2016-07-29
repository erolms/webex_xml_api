module WebexXmlApi
  module Meeting
    class CreateMeeting
      include WebexXmlApi::Common

      REQUEST_TYPE =
        'java:com.webex.service.binding.meeting.CreateMeeting'.freeze

      attr_accessor :security_context, :meeting
      attr_reader :request, :response

      def initialize(attributes = {})
        @security_context ||= WebexXmlApi::SecurityContext.new(attributes)
        @meeting ||= []
        init_meeting_object
      end

      def to_xml
        raise WebexXmlApi::NotEnoughArguments,
              'Meeting::CreateMeeting' unless valid?
        create_xml_request(@security_context.to_xml, REQUEST_TYPE, @meeting)
      end

      def valid?(context = self)
        return false if context.conf_name.nil?
        return false if context.start_date.nil? || context.duration.nil?
        true
      end

      def send_request
        @request = to_xml
        @response = post_webex_request(security_context.site_name, @request)
        check_response_and_return_data(@response)
      end

      # various getters and setter from here
      def conf_name
        @meeting['metaData']['confName']
      end

      def conf_name=(str)
        @meeting['metaData']['confName'] = str
      end

      def agenda
        @meeting['metaData']['agenda']
      end

      def agenda=(str)
        @meeting['metaData']['agenda'] = str
      end

      def meeting_password
        @meeting['accessControl']['meetingPassword']
      end

      def meeting_password=(str)
        @meeting['accessControl']['meetingPassword'] = str
      end

      def start_date
        @meeting['schedule']['startDate']
      end

      def start_date=(str)
        if str.is_a? String
          @meeting['schedule']['startDate'] = str
        elsif str.is_a? DateTime
          @meeting['schedule']['startDate'] = str.strftime('%m/%d/%Y %H:%M:%S')
        end
      end

      def duration
        @meeting['schedule']['duration']
      end

      def duration=(str)
        @meeting['schedule']['duration'] = str
      end

      def open_time
        @meeting['schedule']['openTime']
      end

      def open_time=(str)
        @meeting['schedule']['openTime'] = str
      end

      def join_teleconf_before_host
        @meeting['schedule']['joinTeleconfBeforeHost']
      end

      def join_teleconf_before_host=(str)
        @meeting['schedule']['joinTeleconfBeforeHost'] = str
      end

      def first_attendee_as_presenter
        @meeting['schedule']['firstAttendeeAsPresenter']
      end

      def first_attendee_as_presenter=(str)
        @meeting['schedule']['firstAttendeeAsPresenter'] = str
      end

      def telephony_support
        @meeting['telephony']['telephonySupport']
      end

      def telephony_support=(str)
        @meeting['telephony']['telephonySupport'] = str
      end

      def intl_local_call_in
        @meeting['telephony']['intlLocalCallIn']
      end

      def intl_local_call_in=(str)
        @meeting['telephony']['intlLocalCallIn'] = str
      end

      def teleconf_location
        @meeting['telephony']['teleconfLocation']
      end

      def teleconf_location=(str)
        @meeting['telephony']['teleconfLocation'] = str
      end

      # rubocop:disable PredicateName
      def is_mp_audio
        @meeting['telephony']['isMPAudio']
      end

      def is_mp_audio=(str)
        @meeting['telephony']['isMPAudio'] = str
      end
      # rubocop:enable PredicateName

      def enable_chat
        @meeting['enableOptions']['chat']
      end

      def enable_chat=(str)
        @meeting['enableOptions']['chat'] = str
      end

      def enable_audio_video
        @meeting['enableOptions']['audioVideo']
      end

      def enable_audio_video=(str)
        @meeting['enableOptions']['audioVideo'] = str
      end

      private

      def init_meeting_object
        @meeting = {
          'accessControl' => {
            'listToPublic' => nil,
            'isPublic' => nil,
            'meetingPassword' => nil,
            'enforcePassword' => nil
          },
          'metaData' => {
            'confName' => nil,
            'meetingType' => nil,
            'agenda' => nil,
            'greeting' => nil,
            'location' => nil,
            'invitation' => nil,
            'setNonMTOptions' => nil,
            'sessionTemplate' => nil,
            'isInternal' => nil
          },
          'schedule' => {
            'startDate' => nil,
            'timeZoneID' => nil,
            'timeZone' => nil,
            'duration' => nil,
            'openTime' => nil,
            'hostWebExID' => nil,
            'templateFilePath' => nil,
            'showFilePath' => nil,
            'showFileStartMode' => nil,
            'showFileContPlayFlag' => nil,
            'showFileInterVal' => nil,
            'entryExitTone' => nil,
            'extURL' => nil,
            'extNotifyTime' => nil,
            'joinNotifyURL' => nil,
            'joinTeleconfBeforeHost' => nil,
            'firstAttendeeAsPresenter' => nil
          },
          'telephony' => {
            'telephonySupport' => nil,
            'numPhoneLines' => nil,
            'extTelephonyURL' => nil,
            'extTelephonyDescription' => nil,
            'enableTSP' => nil,
            'tspAccountIndex' => nil,
            'personalAccountIndex' => nil,
            'intlLocalCallIn' => nil,
            'teleconfLocation' => nil,
            'callInNum' => nil,
            'tspConference' => nil,
            'tspAccessCodeOrder' => nil,
            'tollFree' => nil,
            'isMPAudio' => nil
          },
          'participants' => {
            'maxUserNumber' => nil,
            'attendees' => nil
          },
          'enableOptions' => {
            'chat' => nil,
            'poll' => nil,
            'audioVideo' => nil,
            'attendeeList' => nil,
            'fileShare' => nil,
            'presentation' => nil,
            'applicationShare' => nil,
            'desktopShare' => nil,
            'webTour' => nil,
            'meetingRecord' => nil,
            'annotation' => nil,
            'importDocument' => nil,
            'saveDocument' => nil,
            'printDocument' => nil,
            'pointer' => nil,
            'switchPage' => nil,
            'fullScreen' => nil,
            'thumbnail' => nil,
            'zoom' => nil,
            'copyPage' => nil,
            'rcAppShare' => nil,
            'rcDesktopShare' => nil,
            'rcWebTour' => nil,
            'javaClient' => nil,
            'nativeClient' => nil,
            'attendeeRecordMeeting' => nil,
            'voip' => nil,
            'faxIntoMeeting' => nil,
            'enableReg' => nil,
            'supportQandA' => nil,
            'supportFeedback' => nil,
            'supportBreakoutSessions' => nil,
            'supportPanelists' => nil,
            'supportRemoteComputer' => nil,
            'supportShareWebContent' => nil,
            'supportUCFWebPages' => nil,
            'supportUCFRichMedia' => nil,
            'autoDeleteAfterMeetingEnd' => nil,
            'viewAnyDoc' => nil,
            'viewAnyPage' => nil,
            'allowContactPrivate' => nil,
            'chatHost' => nil,
            'chatPresenter' => nil,
            'chatAllAttendees' => nil,
            'multiVideo' => nil,
            'notes' => nil,
            'closedCaptions' => nil,
            'singleNote' => nil,
            'sendFeedback' => nil,
            'displayQuickStartHost' => nil,
            'displayQuickStartAttendees' => nil,
            'supportE2E' => nil,
            'supportPKI' => nil,
            'HQvideo' => nil,
            'HDvideo' => nil,
            'viewVideoThumbs' => nil
          },
          'tracking' => {
            'trackingCode1' => nil,
            'trackingCode2' => nil,
            'trackingCode3' => nil,
            'trackingCode4' => nil,
            'trackingCode5' => nil,
            'trackingCode6' => nil,
            'trackingCode7' => nil,
            'trackingCode8' => nil,
            'trackingCode9' => nil,
            'trackingCode10' => nil
          },
          'repeat' => {
            'repeatType' => nil,
            'interval' => nil,
            'afterMeetingNumber' => nil,
            'dayInWeek' => nil,
            'expirationDate' => nil,
            'dayInMonth' => nil,
            'weekInMonth' => nil,
            'monthInYear' => nil,
            'dayInYear' => nil,
            'isException' => nil,
            'seriesMeetingKey' => nil,
            'hasException' => nil
          },
          'remind' => {
            'enableReminder' => nil,
            'emails' => nil,
            'sendEmail' => nil,
            'mobile' => nil,
            'sendMobile' => nil,
            'daysAhead' => nil,
            'hoursAhead' => nil,
            'minutesAhead' => nil
          },
          'attendeeOptions' => {
            'request' => nil,
            'registration' => nil,
            'auto' => nil,
            'emailInvitations' => nil,
            'participantLimit' => nil,
            'excludePassword' => nil,
            'joinRequiresAccount' => nil
          },
          'assistService' => {
            'assistRequest' => nil,
            'assistConfirm' => nil
          }
        }
      end
    end
  end
end
