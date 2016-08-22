module WebexXmlApi
  module Meeting
    ##
    # The +CreateMeeting+ Class sends a Create Meeting request to the WebEx
    # XML API Service and returns a Hash with the meeting key of the newly
    # created meeting
    #
    class CreateMeeting
      include WebexXmlApi::Common

      # XML Request Type for the <tt>WebexXmlApi::Meeting::CreateMeeting</tt>
      # service
      REQUEST_TYPE =
        'java:com.webex.service.binding.meeting.CreateMeeting'.freeze

      # Accessor methods for meeting and security_context object
      attr_accessor :security_context, :meeting
      # Reader methods for request and response objects
      attr_reader :request, :response

      ##
      # The +initialize+ method for newly created instance parsing provided
      # parameters (if any). The +initialize+ method automaticaly creates
      # new +SecurityContext+ instance and passes the attribes.
      #
      def initialize(attributes = {})
        @security_context ||= WebexXmlApi::SecurityContext.new(attributes)
        @meeting ||= []
        init_meeting_object
      end

      ##
      # The +to_xml+ method returns XML representation of the
      # <tt>WebexXmlApi::Meeting::CreateMeeting</tt> instance as understood by
      # the WebEx XML Service.
      #
      def to_xml
        raise WebexXmlApi::NotEnoughArguments,
              'Meeting::CreateMeeting' unless valid?
        create_xml_request(@security_context.to_xml, REQUEST_TYPE, @meeting)
      end

      ##
      # Returns true if required parameters provided, otherwise false.
      #
      def valid?(context = self)
        return false if context.conf_name.nil?
        return false if context.start_date.nil? || context.duration.nil?
        true
      end

      ##
      # The +send_request+ method will issue the XML API request to WebEx,
      # parse the results and return data if successful. Upon failure an
      # exception is raised.
      #
      def send_request
        @request = to_xml
        @response = post_webex_request(security_context.site_name, @request)
        check_response_and_return_data(@response)
      end

      # ----------------------------------
      # :section: Getter and Setter Methods
      # A selection of getter and setter methods for easier access to the
      # instance variables based on the experience using the WebEx Service.
      # ----------------------------------

      # The +conf_name+ getter
      def conf_name
        @meeting['metaData']['confName']
      end

      # The +conf_name+ setter
      def conf_name=(str)
        @meeting['metaData']['confName'] = str
      end

      # The +agenda+ getter
      def agenda
        @meeting['metaData']['agenda']
      end

      # The +agenda+ setter
      def agenda=(str)
        @meeting['metaData']['agenda'] = str
      end

      # The +meeting_password+ getter
      def meeting_password
        @meeting['accessControl']['meetingPassword']
      end

      # The +meeting_password+ setter
      def meeting_password=(str)
        @meeting['accessControl']['meetingPassword'] = str
      end

      # The +start_date+ getter
      def start_date
        @meeting['schedule']['startDate']
      end

      # The +start_date+ setter
      # Paremeter provided can be either a String in a MM/DD/YYYY HH:MI:SS
      # format or a DateTime object that is formatted to fit the WebEx format.
      def start_date=(str)
        if str.is_a? String
          @meeting['schedule']['startDate'] = str
        elsif str.is_a? DateTime
          @meeting['schedule']['startDate'] = str.strftime('%m/%d/%Y %H:%M:%S')
        end
      end

      # The +duration+ getter
      def duration
        @meeting['schedule']['duration']
      end

      # The +duration+ setter
      def duration=(str)
        @meeting['schedule']['duration'] = str
      end

      # The +open_time+ getter
      def open_time
        @meeting['schedule']['openTime']
      end

      # The +open_time+ setter
      def open_time=(str)
        @meeting['schedule']['openTime'] = str
      end

      # The +join_teleconf_before_host+ getter
      def join_teleconf_before_host
        @meeting['schedule']['joinTeleconfBeforeHost']
      end

      # The +join_teleconf_before_host+ setter
      def join_teleconf_before_host=(str)
        @meeting['schedule']['joinTeleconfBeforeHost'] = str
      end

      # The +first_attendee_as_presenter+ getter
      def first_attendee_as_presenter
        @meeting['schedule']['firstAttendeeAsPresenter']
      end

      # The +first_attendee_as_presenter+ setter
      def first_attendee_as_presenter=(str)
        @meeting['schedule']['firstAttendeeAsPresenter'] = str
      end

      # The +telephony_support+ getter
      def telephony_support
        @meeting['telephony']['telephonySupport']
      end

      # The +telephony_support+ setter
      def telephony_support=(str)
        @meeting['telephony']['telephonySupport'] = str
      end

      # The +intl_local_call_in+ getter
      def intl_local_call_in
        @meeting['telephony']['intlLocalCallIn']
      end

      # The +intl_local_call_in+ setter
      def intl_local_call_in=(str)
        @meeting['telephony']['intlLocalCallIn'] = str
      end

      # The +teleconf_location+ getter
      def teleconf_location
        @meeting['telephony']['teleconfLocation']
      end

      # The +teleconf_location+ setter
      def teleconf_location=(str)
        @meeting['telephony']['teleconfLocation'] = str
      end

      # The +is_mp_audio+ getter
      # rubocop:disable PredicateName
      def is_mp_audio
        @meeting['telephony']['isMPAudio']
      end

      # The +is_mp_audio+ setter
      def is_mp_audio=(str)
        @meeting['telephony']['isMPAudio'] = str
      end
      # rubocop:enable PredicateName

      # The +enable_chat+ getter
      def enable_chat
        @meeting['enableOptions']['chat']
      end

      # The +enable_chat+ setter
      def enable_chat=(str)
        @meeting['enableOptions']['chat'] = str
      end

      # The +enable_audio_video+ getter
      def enable_audio_video
        @meeting['enableOptions']['audioVideo']
      end

      # The +enable_audio_video+ setter
      def enable_audio_video=(str)
        @meeting['enableOptions']['audioVideo'] = str
      end

      # The +enable_attendee_list+ getter
      def enable_attendee_list
        @meeting['enableOptions']['attendeeList']
      end

      # The +enable_attendee_list+ setter
      def enable_attendee_list=(str)
        @meeting['enableOptions']['attendeeList'] = str
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
