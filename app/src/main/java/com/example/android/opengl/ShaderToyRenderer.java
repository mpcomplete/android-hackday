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


// Shadertoy specific inputs
//
// vec3	        iResolution	image	The viewport resolution (z is pixel aspect ratio, usually 1.0)
// float	    iGlobalTime	image/sound	Current time in seconds
// float	    iChannelTime[4]	image	Time for channel (if video or sound), in seconds
// vec3	        iChannelResolution0..3	image/sound	Input texture resolution for each channel
// vec4	        iMouse	image	xy = current pixel coords (if LMB is down). zw = click pixel
// sampler2D	iChannel{i}	image/sound	Sampler for input textures i
// vec4	iDate	image/sound	Year, month, day, time in seconds in .xyzw
// float	    iSampleRate	image/sound	The sound sample rate (typically 44100)
public class ShaderToyRenderer implements GLSurfaceView.Renderer {
    static final int COORDS_PER_VERTEX = 3;
    static final int VERTEX_STRIDE     = COORDS_PER_VERTEX * 4;

    private int program;
    private FloatBuffer vertexBuffer;
    private ShortBuffer drawOrderBuffer;
    private int drawOrderLength;
    private String vertexShaderSrc;
    private String fragmentShaderSrc;

    public ShaderToyRenderer(String vSrc, String fSrc) {
        vertexShaderSrc = vSrc;
        fragmentShaderSrc = fSrc;
    }

    @Override
    public void onSurfaceCreated(GL10 unused, EGLConfig config) {
        GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        program = GLUtils.programFromSrc(vertexShaderSrc, fragmentShaderSrc);

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

        drawVertexBuffer(vertexBuffer, drawOrderBuffer, drawOrderLength);
    }

    @Override
    public void onSurfaceChanged(GL10 unused, int width, int height) {
        GLES20.glViewport(0, 0, width, height);
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
        final float color[] = {0.2f, 0.709803922f, 0.898039216f, 1.0f};
        int colorHandle = GLES20.glGetUniformLocation(program, "vColor");
        GLES20.glUniform4fv(colorHandle, 1, color, 0);

        int positionHandle  = GLES20.glGetAttribLocation(program, "a_position");
        GLES20.glEnableVertexAttribArray(positionHandle);
        GLES20.glVertexAttribPointer(
            positionHandle, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, VERTEX_STRIDE, vertexBuffer);
        GLES20.glDrawElements(
            GLES20.GL_TRIANGLES, drawOrderLength,
            GLES20.GL_UNSIGNED_SHORT, drawOrderBuffer);
        GLES20.glDisableVertexAttribArray(positionHandle);
    }
}
