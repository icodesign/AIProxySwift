//
//  OpenAIRealtimeSessionConfiguration.swift
//  AIProxy
//
//  Created by Lou Zell on 2/23/25.
//

/// Realtime session configuration
/// https://platform.openai.com/docs/api-reference/realtime-client-events/session/update#realtime-client-events/session/update-session
///
///
nonisolated public enum OpenAIRealtimeSessionType: String, Encodable, Sendable {
    case realtime = "realtime"
    case transcription = "transcription"
}

nonisolated public struct OpenAIRealtimeSessionAudioConfiguration: Encodable, Sendable {
    
    nonisolated public enum AudioFormat: Encodable, Sendable {
        case pcm
        case pcmu
        case pcma
        
        private enum CodingKeys: String, CodingKey {
            case type
            case rate
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .pcm:
                try container.encode("audio/pcm", forKey: .type)
                try container.encode(24000, forKey: .rate)
            case .pcmu:
                try container.encode("audio/pcmu", forKey: .type)
            case .pcma:
                try container.encode("audio/pcma", forKey: .type)
            }
        }
    }
    
    nonisolated public enum NoiseReduction: Encodable, Sendable {
        case nearField
        case farField
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .nearField:
                try container.encode("near_field")
            case .farField:
                try container.encode("far_field")
            }
        }
    }
    
    nonisolated public struct Transcription: Encodable, Sendable {
        public let language: String?
        public let model: String?
        public let prompt: String?
        
        public init(language: String?, model: String?, prompt: String?) {
            self.language = language
            self.model = model
            self.prompt = prompt
        }
        
        private enum CodingKeys: String, CodingKey {
            case language
            case model
            case prompt
        }
    }
    
    nonisolated public enum TurnDetection: Encodable, Sendable {
        nonisolated public enum Eagerness: String, Encodable, Sendable {
            case low
            case medium
            case high
            case auto
        }

        /// Server-side voice activity detection (VAD)
        /// - Parameters:
        ///   - createResponse: Whether to automatically generate a response when VAD stop event occurs
        ///   - interruptResponse: Whether to automatically interrupt any ongoing response when VAD start event occurs
        ///   - prefixPaddingMs: Amount of audio to include before speech starts (default: 300ms)
        ///   - silenceDurationMs: Duration of silence to detect speech stop (default: 500ms)
        ///   - threshold: Activation threshold for VAD, 0.0 to 1.0 (default: 0.5)
        ///   - idleTimeoutMs: Optional timeout after which a model response will be triggered automatically
        case serverVAD(
            createResponse: Bool? = nil,
            interruptResponse: Bool? = nil,
            prefixPaddingMs: Int? = nil,
            silenceDurationMs: Int? = nil,
            threshold: Double? = nil,
            idleTimeoutMs: Int? = nil
        )

        /// Semantic voice activity detection using a model to determine when user has finished speaking
        /// - Parameters:
        ///   - createResponse: Whether to automatically generate a response when VAD stop event occurs
        ///   - interruptResponse: Whether to automatically interrupt any ongoing response when VAD start event occurs
        ///   - eagerness: How eagerly the model responds (low: 8s max, medium: 4s max, high: 2s max, auto: default/medium)
        case semanticVAD(
            createResponse: Bool? = nil,
            interruptResponse: Bool? = nil,
            eagerness: Eagerness? = nil
        )

        private enum CodingKeys: String, CodingKey {
            case type
            case createResponse = "create_response"
            case interruptResponse = "interrupt_response"
            case prefixPaddingMs = "prefix_padding_ms"
            case silenceDurationMs = "silence_duration_ms"
            case threshold
            case idleTimeoutMs = "idle_timeout_ms"
            case eagerness
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch self {
            case .serverVAD(let createResponse, let interruptResponse, let prefixPaddingMs, let silenceDurationMs, let threshold, let idleTimeoutMs):
                try container.encode("server_vad", forKey: .type)
                try container.encodeIfPresent(createResponse, forKey: .createResponse)
                try container.encodeIfPresent(interruptResponse, forKey: .interruptResponse)
                try container.encodeIfPresent(prefixPaddingMs, forKey: .prefixPaddingMs)
                try container.encodeIfPresent(silenceDurationMs, forKey: .silenceDurationMs)
                try container.encodeIfPresent(threshold, forKey: .threshold)
                try container.encodeIfPresent(idleTimeoutMs, forKey: .idleTimeoutMs)

            case .semanticVAD(let createResponse, let interruptResponse, let eagerness):
                try container.encode("semantic_vad", forKey: .type)
                try container.encodeIfPresent(createResponse, forKey: .createResponse)
                try container.encodeIfPresent(interruptResponse, forKey: .interruptResponse)
                try container.encodeIfPresent(eagerness, forKey: .eagerness)
            }
        }
    }
    
    nonisolated public struct AudioInputConfiguration: Encodable, Sendable {
        public let format: AudioFormat
        public let noiseReduction: NoiseReduction?
        public let transcription: Transcription?
        public let turnDection: TurnDetection?

        public init(
            format: AudioFormat,
            noiseReduction: NoiseReduction? = nil,
            transcription: Transcription? = nil,
            turnDection: TurnDetection? = nil
        ) {
            self.format = format
            self.noiseReduction = noiseReduction
            self.transcription = transcription
            self.turnDection = turnDection
        }
        
        private enum CodingKeys: String, CodingKey {
            case format
            case noiseReduction = "noise_reduction"
            case transcription
            case turnDection = "turn_detection"
        }
    }

    nonisolated public enum Voice: Encodable, Sendable {
        /// Built-in voice names
        case alloy
        case ash
        case ballad
        case coral
        case echo
        case sage
        case shimmer
        case verse
        case marin
        case cedar

        /// Custom voice with ID
        case custom(id: String)

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .alloy:
                try container.encode("alloy")
            case .ash:
                try container.encode("ash")
            case .ballad:
                try container.encode("ballad")
            case .coral:
                try container.encode("coral")
            case .echo:
                try container.encode("echo")
            case .sage:
                try container.encode("sage")
            case .shimmer:
                try container.encode("shimmer")
            case .verse:
                try container.encode("verse")
            case .marin:
                try container.encode("marin")
            case .cedar:
                try container.encode("cedar")
            case .custom(let id):
                var nestedContainer = encoder.container(keyedBy: CustomVoiceKeys.self)
                try nestedContainer.encode(id, forKey: .id)
            }
        }

        private enum CustomVoiceKeys: String, CodingKey {
            case id
        }
    }

    nonisolated public struct AudioOutputConfiguration: Encodable, Sendable {
        /// The format of the output audio
        public let format: AudioFormat?

        /// The speed of the model's spoken response as a multiple of the original speed.
        /// Range: 0.25 (minimum) to 1.5 (maximum). Default is 1.0.
        /// Can only be changed between model turns, not while a response is in progress.
        public let speed: Double?

        /// The voice the model uses to respond.
        /// Supported built-in voices: alloy, ash, ballad, coral, echo, sage, shimmer, verse, marin, cedar.
        /// Custom voices can be specified with an id.
        /// Voice cannot be changed during the session once the model has responded with audio at least once.
        /// Recommended: marin and cedar for best quality.
        public let voice: Voice?

        public init(
            format: AudioFormat? = nil,
            speed: Double? = nil,
            voice: Voice? = nil
        ) {
            self.format = format
            self.speed = speed
            self.voice = voice
        }
    }
}

nonisolated public enum OpenAIRealtimeSessionConfiguration: Encodable, Sendable {

    /// Realtime session configuration
    case realtime(
        audio: OpenAIRealtimeSessionAudioConfiguration.AudioConfiguration?,
        include: [String]?,
        instructions: String?,
        maxOutputTokens: MaxOutputTokens?,
        model: String?,
        outputModalities: [OutputModality]?,
        prompt: Prompt?,
        toolChoice: ToolChoice?,
        tools: [Tool]?,
        tracing: Tracing?,
        truncation: Truncation?
    )

    /// Transcription session configuration
    case transcription(
        audio: OpenAIRealtimeSessionAudioConfiguration.AudioConfiguration?,
        include: [String]?
    )

    private enum CodingKeys: String, CodingKey {
        case type
        case audio
        case include
        case instructions
        case maxOutputTokens = "max_output_tokens"
        case model
        case outputModalities = "output_modalities"
        case prompt
        case toolChoice = "tool_choice"
        case tools
        case tracing
        case truncation
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .realtime(let audio, let include, let instructions, let maxOutputTokens, let model, let outputModalities, let prompt, let toolChoice, let tools, let tracing, let truncation):
            try container.encode("realtime", forKey: .type)
            try container.encodeIfPresent(audio, forKey: .audio)
            try container.encodeIfPresent(include, forKey: .include)
            try container.encodeIfPresent(instructions, forKey: .instructions)
            try container.encodeIfPresent(maxOutputTokens, forKey: .maxOutputTokens)
            try container.encodeIfPresent(model, forKey: .model)
            try container.encodeIfPresent(outputModalities, forKey: .outputModalities)
            try container.encodeIfPresent(prompt, forKey: .prompt)
            try container.encodeIfPresent(toolChoice, forKey: .toolChoice)
            try container.encodeIfPresent(tools, forKey: .tools)
            try container.encodeIfPresent(tracing, forKey: .tracing)
            try container.encodeIfPresent(truncation, forKey: .truncation)

        case .transcription(let audio, let include):
            try container.encode("transcription", forKey: .type)
            try container.encodeIfPresent(audio, forKey: .audio)
            try container.encodeIfPresent(include, forKey: .include)
        }
    }
}

// MARK: - Supporting Types

extension OpenAIRealtimeSessionAudioConfiguration {
    nonisolated public struct AudioConfiguration: Encodable, Sendable {
        public let input: AudioInputConfiguration?
        public let output: AudioOutputConfiguration?

        public init(
            input: AudioInputConfiguration? = nil,
            output: AudioOutputConfiguration? = nil
        ) {
            self.input = input
            self.output = output
        }
    }
}

extension OpenAIRealtimeSessionConfiguration {
    nonisolated public enum MaxOutputTokens: Encodable, Sendable {
        case int(Int)
        case infinite

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .int(let value):
                try container.encode(value)
            case .infinite:
                try container.encode("inf")
            }
        }
    }
}

extension OpenAIRealtimeSessionConfiguration {
    nonisolated public enum OutputModality: String, Encodable, Sendable {
        case audio
        case text
    }
}

extension OpenAIRealtimeSessionConfiguration {
    nonisolated public struct Prompt: Encodable, Sendable {
        /// The unique identifier of the prompt template to use
        public let id: String

        /// Optional map of values to substitute in for variables in your prompt
        public let variables: [String: String]?

        /// Optional version of the prompt template
        public let version: String?

        public init(
            id: String,
            variables: [String: String]? = nil,
            version: String? = nil
        ) {
            self.id = id
            self.variables = variables
            self.version = version
        }
    }
}

extension OpenAIRealtimeSessionConfiguration {
    nonisolated public enum ToolChoice: Encodable, Sendable {
        /// The model will not call any tool and instead generates a message
        case none

        /// The model can pick between generating a message or calling one or more tools
        case auto

        /// The model must call one or more tools
        case required

        /// Force the model to call a specific function
        case function(name: String)

        /// Force the model to call a specific MCP tool
        case mcp(serverLabel: String, name: String)

        private enum CodingKeys: String, CodingKey {
            case type
            case name
            case serverLabel = "server_label"
        }

        public func encode(to encoder: any Encoder) throws {
            switch self {
            case .none:
                var container = encoder.singleValueContainer()
                try container.encode("none")
            case .auto:
                var container = encoder.singleValueContainer()
                try container.encode("auto")
            case .required:
                var container = encoder.singleValueContainer()
                try container.encode("required")
            case .function(let name):
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode("function", forKey: .type)
                try container.encode(name, forKey: .name)
            case .mcp(let serverLabel, let name):
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode("mcp", forKey: .type)
                try container.encode(serverLabel, forKey: .serverLabel)
                try container.encode(name, forKey: .name)
            }
        }
    }
}

extension OpenAIRealtimeSessionConfiguration {
    nonisolated public enum Tool: Encodable, Sendable {
        /// Function tool
        case function(name: String, description: String, parameters: [String: AIProxyJSONValue])

        /// MCP tool
        case mcp(
            serverLabel: String,
            allowedTools: AllowedTools?,
            authorization: String?,
            connectorId: String?,
            headers: [String: String]?,
            requireApproval: RequireApproval?,
            serverDescription: String?,
            serverUrl: String?
        )

        public enum AllowedTools: Encodable, Sendable {
            case all
            case specific([String])

            public func encode(to encoder: any Encoder) throws {
                switch self {
                case .all:
                    var container = encoder.singleValueContainer()
                    try container.encode("*")
                case .specific(let tools):
                    var container = encoder.singleValueContainer()
                    try container.encode(tools)
                }
            }
        }

        public enum RequireApproval: Encodable, Sendable {
            case all
            case none
            case specific([String])

            public func encode(to encoder: any Encoder) throws {
                switch self {
                case .all:
                    var container = encoder.singleValueContainer()
                    try container.encode("*")
                case .none:
                    var container = encoder.singleValueContainer()
                    try container.encode("none")
                case .specific(let tools):
                    var container = encoder.singleValueContainer()
                    try container.encode(tools)
                }
            }
        }

        private enum CodingKeys: String, CodingKey {
            case type
            case name
            case description
            case parameters
            case serverLabel = "server_label"
            case allowedTools = "allowed_tools"
            case authorization
            case connectorId = "connector_id"
            case headers
            case requireApproval = "require_approval"
            case serverDescription = "server_description"
            case serverUrl = "server_url"
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch self {
            case .function(let name, let description, let parameters):
                try container.encode("function", forKey: .type)
                try container.encode(name, forKey: .name)
                try container.encode(description, forKey: .description)
                try container.encode(parameters, forKey: .parameters)

            case .mcp(let serverLabel, let allowedTools, let authorization, let connectorId, let headers, let requireApproval, let serverDescription, let serverUrl):
                try container.encode("mcp", forKey: .type)
                try container.encode(serverLabel, forKey: .serverLabel)
                try container.encodeIfPresent(allowedTools, forKey: .allowedTools)
                try container.encodeIfPresent(authorization, forKey: .authorization)
                try container.encodeIfPresent(connectorId, forKey: .connectorId)
                try container.encodeIfPresent(headers, forKey: .headers)
                try container.encodeIfPresent(requireApproval, forKey: .requireApproval)
                try container.encodeIfPresent(serverDescription, forKey: .serverDescription)
                try container.encodeIfPresent(serverUrl, forKey: .serverUrl)
            }
        }
    }
}

extension OpenAIRealtimeSessionConfiguration {
    nonisolated public enum Tracing: Encodable, Sendable {
        /// Enables tracing with default values
        case auto

        /// Custom tracing configuration
        case custom(
            groupId: String?,
            metadata: [String: String]?,
            workflowName: String?
        )

        private enum CodingKeys: String, CodingKey {
            case groupId = "group_id"
            case metadata
            case workflowName = "workflow_name"
        }

        public func encode(to encoder: any Encoder) throws {
            switch self {
            case .auto:
                var container = encoder.singleValueContainer()
                try container.encode("auto")
            case .custom(let groupId, let metadata, let workflowName):
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encodeIfPresent(groupId, forKey: .groupId)
                try container.encodeIfPresent(metadata, forKey: .metadata)
                try container.encodeIfPresent(workflowName, forKey: .workflowName)
            }
        }
    }
}

extension OpenAIRealtimeSessionConfiguration {
    nonisolated public enum Truncation: Encodable, Sendable {
        /// Auto truncation strategy (default)
        case auto

        /// Disable truncation
        case disabled

        /// Retain a fraction of conversation tokens when exceeding input token limit
        case retentionRatio(
            maxTokens: Int,
            retainRatio: Double
        )

        private enum CodingKeys: String, CodingKey {
            case type
            case maxTokens = "max_tokens"
            case retainRatio = "retain_ratio"
        }

        public func encode(to encoder: any Encoder) throws {
            switch self {
            case .auto:
                var container = encoder.singleValueContainer()
                try container.encode("auto")
            case .disabled:
                var container = encoder.singleValueContainer()
                try container.encode("disabled")
            case .retentionRatio(let maxTokens, let retainRatio):
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode("retention_ratio", forKey: .type)
                try container.encode(maxTokens, forKey: .maxTokens)
                try container.encode(retainRatio, forKey: .retainRatio)
            }
        }
    }
}

