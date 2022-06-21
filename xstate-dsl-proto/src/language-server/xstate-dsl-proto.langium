grammar XstateDslProto

entry Model:
    ('machine' machineID=ID)?
    (services+=ServiceDeclaration | conditions+=ConditionDeclaration | actions+=ActionDeclaration)*
    initial=InitialState
    states+=StateConfig*;

InitialState:
    'initial' stateId=[StateConfig:ID];

StateConfig:
    'state' (final?='final')? name=ID (BRACE_OPEN children+=StateConfig* transitions+=EventConfig* BRACE_CLOSE)?
    ('entry' entryConfig=ActionConfig)? 
    ('exit' exitConfig=ActionConfig)?
    ('invoke' invokeConfig=ServiceInvokeConfig)?;

ActionSimpleConfig:
    ('when' condition=[ConditionDeclaration:ID])? 'apply' actionRef=[ActionDeclaration:ID];
ActionListEntryConfig: // converts to xstate's choose-action
    'case' (condition=[ConditionDeclaration:ID] | default?='default') 'apply' actionRef=[ActionDeclaration:ID];
ActionListConfig:
    BRACE_OPEN actionConfigs+=ActionListEntryConfig+ BRACE_CLOSE;
ActionConfig: (ActionSimpleConfig | ActionListConfig);

TransitionSimpleTarget:
    ('when' condition=[ConditionDeclaration:ID])? ARROW targetId=[StateConfig:ID] ('apply' actionRef=[ActionDeclaration:ID])?;
TransitionListTargetEntry:
   'case' (condition=[ConditionDeclaration:ID] | default?='default') ARROW targetId=[StateConfig:ID] ('apply' actionRef=[ActionDeclaration:ID])?;
TransitionListTarget:
   BRACE_OPEN targetConfigs+=TransitionListTargetEntry+ BRACE_CLOSE;

TransitionConfig: (TransitionSimpleTarget | TransitionListTarget);

EventConfig:
    'on' name=ID TransitionConfig;

ServiceAsyncActionConfig:
    ('done' TransitionConfig)? ('error' TransitionConfig)?;

//ServiceWithCommunicationContractConfig: ;

ServiceInvokeConfig:
    serviceId=[ServiceDeclaration:ID] ServiceAsyncActionConfig;

ActionDeclaration:
    'action' (type?='assign' | type?='send')? name=ID;

ServiceDeclaration:
    'service' name=ID;

ConditionDeclaration:
    'cond' name=ID;

//QualifiedName returns string: '#' ID ('.' ID)*;
terminal ARROW: '->';
hidden terminal WS: /\s+/;
terminal ID: /[_a-zA-Z][\w_]*/;
terminal INT returns number: /[0-9]+/;
terminal STRING: /"[^"]*"|'[^']*'/;
terminal BRACE_OPEN: '{';
terminal BRACE_CLOSE: '}';

hidden terminal ML_COMMENT: /\/\*[\s\S]*?\*\//;
hidden terminal SL_COMMENT: /\/\/[^\n\r]*/;