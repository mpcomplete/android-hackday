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

import android.app.Activity;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Spinner;

public class OpenGLES20Activity extends Activity implements AdapterView.OnItemSelectedListener {

    private GLSurfaceView mGLView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ShaderToyRenderer.ShaderSpec shader = new ShaderToyRenderer.ShaderSpec();
        shader.fragmentSrc = GLUtils.loadText(this, R.raw.frag);
        shader.textureResources = new int[]{R.drawable.tex03, R.drawable.tex16};
        mGLView = new MyGLSurfaceView(this, shader);
        setContentView(mGLView);
    }

    public boolean onCreateOptionsMenu (Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.activity_menu, menu);
        menu.getItem(0).getActionView().findViewById(R.id.spinner);

        Spinner spinner = (Spinner) menu.getItem(0).getActionView().findViewById(R.id.spinner);
        spinner.setOnItemSelectedListener(this);
        return super.onCreateOptionsMenu(menu);
    }

    public void onItemSelected(AdapterView<?> parent,
                               View view,
                               int pos,
                               long id) {

        Object selected = parent.getItemAtPosition(pos);
        String name     = selected.toString();
        Log.d("Selection", name);

        ShaderToyRenderer.ShaderSpec shader = new ShaderToyRenderer.ShaderSpec();
        if (pos == 1) {
            shader.fragmentSrc = GLUtils.loadText(this, R.raw.frag);
            shader.textureResources = new int[]{R.drawable.tex03, R.drawable.tex16};
        } else {
            shader.fragmentSrc = GLUtils.loadText(this, R.raw.clouds);
            shader.textureResources = new int[]{R.drawable.tex16};
        }
        mGLView = new MyGLSurfaceView(this, shader);
        setContentView(mGLView);
    }

    public void onNothingSelected(AdapterView<?> parent) {
        // Another interface callback
    }

    @Override
    protected void onPause() {
        super.onPause();
        mGLView.onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
        mGLView.onResume();
    }
}