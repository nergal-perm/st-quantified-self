Class {
	#name : #SqsMockDashboard,
	#superclass : #SqsDashboard,
	#category : #StQuantifiedSelf
}

{ #category : #'as yet unclassified' }
SqsMockDashboard >> fullResponseFromNeo4j [
	readConnectors 
		on: #dayLinks: with: '2024-05-23' asDate respond: '{"data":{"fields":["n","r","d"],"values":[[{"elementId":"4:8928852e-fe2c-46bb-94ab-1747431fb98e:6","labels":["Journal","Summary"],"properties":{"content":"Сегодня у меня день рождения."}},{"elementId":"5:8928852e-fe2c-46bb-94ab-1747431fb98e:1","startNodeElementId":"4:8928852e-fe2c-46bb-94ab-1747431fb98e:6","endNodeElementId":"4:8928852e-fe2c-46bb-94ab-1747431fb98e:5","type":"SUMMARIZES","properties":{}},{"elementId":"4:8928852e-fe2c-46bb-94ab-1747431fb98e:5","labels":["Day"],"properties":{"name":"2024-05-23"}}]]},"bookmarks":["FB:kcwQiSiFLv4sRruUqxdHQx+5jhqQ"]}'
]

{ #category : #initalization }
SqsMockDashboard >> initialize [
	readConnectors := MockObject new.
	self fullResponseFromNeo4j
]
