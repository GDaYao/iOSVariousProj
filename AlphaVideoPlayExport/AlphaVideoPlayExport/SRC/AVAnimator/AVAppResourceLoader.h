//
//  AVAppResourceLoader.h
//
//  Created by Moses DeJong on 7/13/10.
//
//  License terms defined in License.txt.
//
// The AVAppResourceLoader class implements loading of animation
// data from the compiled in app resources of an iOS project.
// An app resource file does not need to be copied into the tmp
// dir, it can be opened and read like and other file, so no
// intermediate tmp files are needed.

/** func:
 
 AVAppResourceLoader 类从iOS项目的已编译应用程序资源中实现动画数据的加载。
应用程序资源文件不需要复制到tmp目录中，可以像其他文件一样打开和读取，因此不需要中间的tmp文件。
 
 */


#import <Foundation/Foundation.h>

#import "AVResourceLoader.h"

#import "AVAppResourceLoader.h"

@interface AVAppResourceLoader : AVResourceLoader {
	NSString *m_movieFilename;
	NSString *m_audioFilename;
}

// Both filename properties can be either a fully qualified file path
// or a simple filename. A simple filename is assumed to be a resource.

@property (nonatomic, copy) NSString *movieFilename;
@property (nonatomic, copy) NSString *audioFilename;

+ (AVAppResourceLoader*) aVAppResourceLoader;

- (BOOL) isReady;

// Note that invoking load multiple times is not going to cause problems,
// multiple requests will be ignored since the cached file would already
// exist when the next request comes in.

- (void) load;

// Non-Public methods

- (NSString*) _getMoviePath;

- (NSString*) _getAudioPath:(NSString*)audioFilename;

@end
