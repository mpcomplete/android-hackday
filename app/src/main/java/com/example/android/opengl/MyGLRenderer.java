/*
 * Copyright (C) 2011 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.example.android.opengl;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.opengl.GLES20;
import android.opengl.GLSurfaceView;
import android.opengl.Matrix;
import android.util.Log;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.ShortBuffer;

public class MyGLRenderer implements GLSurfaceView.Renderer {

    static final int COORDS_PER_VERTEX = 3;
    static final int VERTEX_STRIDE     = COORDS_PER_VERTEX * 4;


    private int program;
    private FloatBuffer vertexBuffer;
    private ShortBuffer drawOrderBuffer;
    private int drawOrderLength;

    public MyGLRenderer (String vSrc, String fSrc) {
        super();
        program = GLUtils.programFromSrc(vSrc, fSrc);
    }

    @Override
    public void onSurfaceCreated(GL10 unused, EGLConfig config) {
        GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

        final float squareCoords[] = {
            -1.0f,  -1.0f, 0.0f,
            -1.0f,   1.0f, 0.0f,
             1.0f,   1.0f, 0.0f,
             1.0f,  -1.0f, 0.0f,
        };
        final short drawOrder[] = {0, 1, 2, 0, 2, 3};
        vertexBuffer = createBuffer(squareCoords);
        drawOrderBuffer = createBuffer(drawOrder);
        drawOrderLength = drawOrder.length;
    }

    @Override
    public void onDrawFrame(GL10 unused) {
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT | GLES20.GL_DEPTH_BUFFER_BIT);
        GLES20.glUseProgram(program);

        final float color[] = {0.2f, 0.709803922f, 0.898039216f, 1.0f};
        int colorHandle = GLES20.glGetUniformLocation(program, "vColor");
        GLES20.glUniform4fv(colorHandle, 1, color, 0);
        drawVertexBuffer(vertexBuffer, drawOrderBuffer, drawOrderLength);
    }

    @Override
    public void onSurfaceChanged(GL10 unused, int width, int height) {
        GLES20.glViewport(0, 0, width, height);
    }

    public static int loadShader(int type, String shaderCode) {
        int shader = GLES20.glCreateShader(type);

        GLES20.glShaderSource(shader, shaderCode);
        GLES20.glCompileShader(shader);
        return shader;
    }

    public static FloatBuffer createBuffer(float[] array) {
        ByteBuffer bb = ByteBuffer.allocateDirect(array.length * 4);  // 4 bytes per float
        bb.order(ByteOrder.nativeOrder());
        FloatBuffer buffer = bb.asFloatBuffer();
        buffer.put(array);
        buffer.position(0);
        return buffer;
    }

    public static ShortBuffer createBuffer(short[] array) {
        ByteBuffer bb = ByteBuffer.allocateDirect(array.length * 2);  // 2 bytes per short
        bb.order(ByteOrder.nativeOrder());
        ShortBuffer buffer = bb.asShortBuffer();
        buffer.put(array);
        buffer.position(0);
        return buffer;
    }

    public void drawVertexBuffer(FloatBuffer vertexBuffer,
                                        ShortBuffer drawOrderBuffer,
                                        int drawOrderLength) {
        int positionHandle  = GLES20.glGetAttribLocation(program, "vPosition");

        GLES20.glEnableVertexAttribArray(positionHandle);
        GLES20.glVertexAttribPointer(
            positionHandle, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, VERTEX_STRIDE, vertexBuffer);
        GLES20.glDrawElements(
            GLES20.GL_TRIANGLES, drawOrderLength,
            GLES20.GL_UNSIGNED_SHORT, drawOrderBuffer);
        GLES20.glDisableVertexAttribArray(positionHandle);
    }

}