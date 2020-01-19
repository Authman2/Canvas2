//
//  Shader.metal
//  Canvas2
//
//  Created by Adeola Uthman on 1/14/20.
//  Copyright © 2020 Adeola Uthman. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


struct Vertex {
    float4 position [[position]];
    float4 color;
    float2 textureCoords [[attribute(2)]];
};

vertex Vertex main_vertex(const device Vertex* vertices [[ buffer(0) ]], unsigned int vid [[ vertex_id ]]) {
    Vertex output;
    
    output.position = vertices[vid].position;
    output.color = vertices[vid].color;
    output.textureCoords = vertices[vid].textureCoords;
    
    return output;
};

fragment half4 main_fragment(Vertex vert [[stage_in]]) {
    return half4(vert.color);
};

fragment half4 textured_fragment(Vertex vert [[stage_in]], sampler sampler2D [[sampler(0)]], texture2d<float> texture [[texture(0)]]) {
    // If there's a texture, display that mixed with the current color.
    if(vert.textureCoords[0] != -1 && vert.textureCoords[1] != -1) {
        float4 txtr = texture.sample(sampler2D, float2(vert.textureCoords[0], vert.textureCoords[1]));
        float4 clr = vert.color;
        float4 blended = mix(txtr, clr, 0.5); // Blend exactly halfway between the texture and color.
        return half4(blended);
    }
    // Otherwise, just show the brush color.
    else {
        return half4(vert.color);
    }
}
