Class {
	#name : #SqsDashboard,
	#superclass : #Object,
	#instVars : [
		'date',
		'announcer',
		'query'
	],
	#category : #StQuantifiedSelf
}

{ #category : #'instance creation' }
SqsDashboard class >> of: aDate [
	 ^ self new
	 	date: aDate;
	 	query: (SqsNeo4jQuery forDay: aDate asDate) 
]

{ #category : #'instance creation' }
SqsDashboard class >> today [
	^ SqsDashboard of: Date today yyyymmdd
]

{ #category : #accessing }
SqsDashboard >> announcer [
	^ announcer
]

{ #category : #widgets }
SqsDashboard >> calendarWidget [
	| calendar |
	calendar := GtCalendarElement forDate: self date.
	calendar
		when: GtCalendarDateClickedEvent
		do: [ :event | self date: event date. self announcer announce: SqsDateChanged ].
	^ calendar
]

{ #category : #accessing }
SqsDashboard >> date [
	^ date
]

{ #category : #accessing }
SqsDashboard >> date: aDate [ 
	date := aDate asDate
]

{ #category : #widgets }
SqsDashboard >> daySummaryEditorWidget [
	| snippetViewModel snippet |
	snippet := self hasJournalSummary
			ifTrue: [ LeTextSnippet string: self query asJournalSummary ]
			ifFalse: [ LeTextSnippet string: 'No journal entry for this day' ].
	snippetViewModel := snippet asSnippetViewModel.
	snippetViewModel coderViewModel
		addShortcut: (BrEditorShortcut lineEnding
				combination: (LeSnippetElement keyboardShortcut: #NewLine)).
	snippetViewModel coderViewModel
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryS;
				action: [ :anEvent "self journalFile
						writeStreamDo: [ :stream | 
							stream truncate.
							(ZnNewLineWriterStream on: stream)
								nextPutAll: anEvent currentTarget text asString ]" |  ]).
	^ ((snippetViewModel snippetView needsEmbellishments: false) asElement
		snippetViewModel: snippetViewModel)
		vMatchParent;
		hExact: 650
]

{ #category : #'view creation' }
SqsDashboard >> gtDashboardFor: aView [
	<gtView>
	^ aView explicit
		title: 'Dashboard';
		priority: 10;
		stencil: [ | container calendar summary mainRow padding10px |
			padding10px := BlInsets all: 10.
			container := BrVerticalPane new
					matchParent;
					padding: padding10px;
					yourself.
			mainRow := BrHorizontalPane new
					matchParent;
					yourself.
			calendar := self calendarWidget
					aptitude: BrShadowAptitude;
					padding: padding10px;
					yourself.
			summary := self daySummaryEditorWidget
					padding: padding10px;
					yourself.
			mainRow addChild: calendar.
			mainRow addChild: summary.
			container addChild: mainRow.
			container ];
		updateWhen: SqsDateChanged in: self announcer
]

{ #category : #'view creation' }
SqsDashboard >> gtJournalFor: aView context: aContext [
	<gtView>
	self hasJournalSummary not ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Journal';
		priority: 10;
		stencil: [ self daySummaryEditorWidget ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Save entry'
			action: [ :aToggle :aTab | 
				self journalFile
					writeStreamDo: [ :stream | 
						stream truncate.
						(ZnNewLineWriterStream on: stream)
							nextPutAll: aTab viewContentElement children first text asString ] ]
]

{ #category : #testing }
SqsDashboard >> hasJournalSummary [
	^ self query hasRows
]

{ #category : #initalization }
SqsDashboard >> initialize [
	announcer := Announcer new
]

{ #category : #accessing }
SqsDashboard >> journalDirectory [
	| basePath |
	basePath := FileLocator home / '.secrets' / 'journal-vault.txt'.
	^ (basePath contents trimBoth, self date year asString) asFileReference
]

{ #category : #'view creation' }
SqsDashboard >> journalFile [
	| parameters request response|
	"^ self journalDirectory / (self date yyyymmdd , '.md')"
	"Should use the preceding line with message 'contents' in the calling code"
	parameters := Dictionary new.
	parameters at: 'name' put: self date yyyymmdd.
	request := Dictionary new.
	request at: 'statement' put: 'MATCH (s:Summary)-[:SUMMARIZES]->(:Day {name: $name}) RETURN s.content'.
	request at: 'parameters' put: parameters.
	request.
	response := STONJSON fromString: (ZnClient new
		url: 'http://localhost:7474/db/quantified-self/query/v2';
		entity: (ZnEntity json: (STONJSON toString: request));
		post).
	^ response
]

{ #category : #accessing }
SqsDashboard >> journalFileName [
	^ self date yyyymmdd , '.md'
]

{ #category : #accessing }
SqsDashboard >> query [
	^ query
]

{ #category : #'instance creation' }
SqsDashboard >> query: aSqsNeo4jQuery [
	query := aSqsNeo4jQuery 
]
